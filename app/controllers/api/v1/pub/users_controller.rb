class Api::V1::Pub::UsersController < Api::V1::BaseController
  def me
    @user = current_user
    render :show
  end

  def unread_message_count
    user = current_user
    render json: {count: user.received_messages.unread_messages.count}
  end

  def following
    @count = current_user.following.count
    @users = current_user.following.page(params[:page]).per(params[:per_page])
  end

  def followers
    @count = current_user.num_of_followers
    @users = current_user.followers.page(params[:page]).per(params[:per_page])
  end

  def search_following
    @users = current_user.search_following(params[:search_term], params[:page], params[:per_page])
  end

  def update_fcm_token
    @user = User.find(params[:id])
    if @user.present?
      @mobile_token = @user.mobile_tokens.find_or_initialize_by(device_token: params[:device_token])
      @mobile_token.update(fcm_token: params[:fcm_token])
      if @mobile_token.update(fcm_token: params[:fcm_token])
        render(:show, status: :ok) && return
      else
        render(json: { errors: @mobile_token.errors.full_messages }, status: :unprocessable_entity) && return
      end
    else
      render(json: { errors: ['User not found'] }, status: :not_found) && return
    end
  end

  def remove_fcm_token
    @user = User.find(params[:id])
    if @user.present?
      @user.mobile_tokens.where(device_token: params[:device_token]).destroy_all
    end
    head(:no_content)
  end

  def profile
    @user = User.find(params[:id])
    @contents = @user.my_contents.page(params[:page]).per(params[:per_page]).order('contents.created_at DESC').includes(:hash_tags)
  end

  def create
    @user = User.new(user_params_for_create)
    @user.skip_confirmation!

    if @user.save
      render(:show, status: :created) && return
    else
      render(json: { errors: @user.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  def update
    @user = User.find(params[:id])
    @user.set_image(:avatar, params[:avatar]) if params[:avatar]
    is_registration_step = @user.is_newbie

    params[:birthdate] = Time.zone.at(user_params_for_update[:birthdate].to_i).to_date
    if @user.update(user_params_for_update)
      if is_registration_step
        DefaultFollowerService.new(@user).assign
      end
      render(:show, status: :ok) && return
    else
      render(json: { errors: @user.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  def cover
    @user = User.find(params[:id])
    @user.set_image(:cover, cover_params)

    if @user.save
      render(:show, status: :ok) && return
    else
      render(json: { errors: @user.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  private

  def user_params_for_create
    params.permit(:email, :password, :password_confirmation)
  end

  def user_params_for_update
    params.permit(:first_name, :last_name, :country, :sex, :birthdate, :biography, :is_newbie, :password, :password_confirmation, :phone_number)
  end

  def cover_params
    params.require(:cover).permit(:base64_data, :original_filename)
  end
end
