class Dashboard::UsersController < ApplicationController
  before_filter :authorize_user, except: :unsubscribe
  before_filter :require_welcome_steps, except: [:profile_avatar, :unsubscribe]
  load_and_authorize_resource
  before_filter :get_displayed_user, except: [:update, :suggested, :unsubscribe]
  respond_to :html, :js, :json

  def show
    redirect_to news_feed_dashboard_user_path(current_user)
  end

  def update
    if current_user.update_without_password(user_params)
      update_current_user_tags!(params[:tags])
      flash[:success] = 'Your account has been updated successfully'
      redirect_to dashboard_user_path(current_user)
    else
      flash[:error] = current_user.errors.full_messages[0]
      redirect_to :back
    end
  end

  def update_password
    if current_user.update_with_password(update_password_params)
      sign_in current_user, bypass: true
      flash[:success] = 'Your password has been updated successfully'
      redirect_to dashboard_user_path(current_user)
    else
      flash[:error] = current_user.errors.full_messages[0]
      redirect_to :back
    end
  end

  def profile
    @contents = @displayed_user.contents.includes(:hash_tags).where.not(content_type: 'daily_story').order(created_at: :desc)
                               .page(params[:page])
    respond_to :html, :js
  end

  def news_feed
    not_found unless current_user == @displayed_user

    @trending_tags = HashTag.trending_tags.limit(16)
    @content  = Content.new
    @contents = NewsfeedService.new(current_user).recent_content
    @contents = @contents.page(params[:page])
                         .includes(:hash_tags, :user)

    @suggested_users = User.suggested_users(current_user).limit(5)
    @mentor = GetMentorService.new.call(current_user)
    if @mentor
      @appointment = Appointment.where(mentor_id: @mentor.id, mentee_id: current_user.id).take
    end
    @conversation = @appointment.conversation if @appointment

    render :show
  end

  def suggested
    @users = User.suggested_users(current_user).page(params[:page])
  end

  def preferences
    @sexs = User::SEX.map { |sex| [sex[:value], sex[:id]] }
    @hash_tags = current_user.hash_tags.pluck(:name).join(',')
  end

  def relationship
    @relation_type = params[:method]
    @relations = @displayed_user.send(@relation_type).page(params[:page])
    # @num_of_relations = @displayed_user.send(@relation_type).count
    render 'relationships/index'
  end

  def profile_avatar
    current_user.upload_profile_avatar = true

    if current_user.update(user_params)
      render :profile_avatar
    else
      render(json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  def profile_cover
    @updated = current_user.update(user_params)
  end

  def unsubscribe
    user = User.find_by_access_token(params[:signature])
    not_found unless user.present?

    user.update_attribute :receive_notification, false
    redirect_to root_path, notice: 'You have successfully unsubscribed.'
  end

  private

  def get_displayed_user
    @displayed_user = User.find(params[:id])
  end

  def update_current_user_tags!(tags)
    current_user.hash_tags = tags.split(',').map do |name|
      HashTag.find_or_create_by name: name
    end
    current_user.save
  end

  def authorize_user
    if !user_signed_in?
      flash[:error] = 'You are not authorized to see this page!'
      redirect_to root_path
    elsif current_user.banned?
      flash[:error] = 'You are banned from our community. For more informations, please contact us.'
      sign_out(current_user)
      redirect_to root_path
    end
  end

  def require_welcome_steps
    if current_user.is_newbie
      flash[:error] = 'Please finish your welcome steps!'

      redirect_to dashboard_welcome_first_path
    end
  end

  def user_params
    attrs = params.require(:user).permit(:email, :first_name, :last_name, :avatar,
                                         :sex, :country, :birthdate, :biography,
                                         :receive_messages_only_from_followers, :receive_notification, :cover)

    if attrs[:birthdate].present?
      attrs[:birthdate] = Date.strptime(attrs[:birthdate], '%m/%d/%Y')
    end
    attrs
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
