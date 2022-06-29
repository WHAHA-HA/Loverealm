class Dashboard::WelcomeController < ApplicationController
  before_filter :restrict_user
  before_filter :assign_followers, only: :user_info
  before_filter :hide_header, only: [:hash_tags, :user_info, :invite_people]

  def hash_tags
    @choosen_tags = current_user.hash_tags.all || []
    @hash_tags = HashTag.limit(20)
    @custom_hash_tags = current_user.hash_tags.where.not(id: @hash_tags)
                                    .map(&:name).join(',')
  end

  def submit_hash_tags
    hash_tags = extract_hash_tags_from_params
    current_user.hash_tags = hash_tags
    current_user.save

    if current_user.hash_tags.size >= 1
      redirect_to dashboard_welcome_second_path
    else
      flash[:alert] = 'Select at least 1 hash tag'
      redirect_to dashboard_welcome_first_path
    end
  end

  def user_info
    @sexs = User::SEX.map { |sex| [sex[:value], sex[:id]] }
  end

  def update_user_info
    if current_user.update_without_password(user_params)
      redirect_to dashboard_welcome_third_path
    else
      redirect_to :back, notice: 'Please fix errors'
    end
  end

  def finish_registration
    # make sure that user went through all required steps
    if current_user.hash_tags.empty?
      redirect_to dashboard_welcome_first_path
    elsif current_user.first_name.blank? || current_user.last_name.blank? ||
          current_user.biography.blank?
      redirect_to dashboard_welcome_second_path
    elsif current_user.is_newbie
      flash[:success] = prepare_message
      current_user.update_attribute(:is_newbie, false)
      create_welcome_message
      redirect_to dashboard_user_path(current_user)
    end
  end

  def invite_people
  end

  def send_invitations
    if params[:emails].present?
      InvitationMailService.new(current_user, params[:emails]).perform
    end

    redirect_to dashboard_finish_registration_path
  end

  private
  def extract_hash_tags_from_params
    hash_tags = HashTag.where(id: params[:hash_tag])
    if params[:tags]
      params[:tags].split(',').each do |tag|
        hash_tags << HashTag.find_or_create_by(name: tag)
      end
    end
    hash_tags
  end

  def create_welcome_message
    admin = User.admins.take
    conversation = Conversation.create(participants: [current_user.id, admin.id])
    message = Message.new(sender_id: admin.id, receiver_id: current_user.id, conversation_id: conversation.id)
    message.body = t('.welcome_message_body', full_name: current_user.full_name,
                                              about_us_page: view_context.link_to('About us', about_us_url),
                                              suggested_users_page: view_context.link_to('suggested users page', suggested_dashboard_users_url),
                                              help_page: view_context.link_to('help page', help_new_url))
    message.subject = t('.welcome_message_subject')
    message.save
  end

  def prepare_message
    if current_user.is_newbie
      "Hello #{current_user.full_name}, welcome to our community. Please check your inbox."
    else
      'You logged in successfully'
    end
  end

  def restrict_user
    if !user_signed_in?
      flash[:error] = 'You are not authorized to see this page!'
      redirect_to root_path
    elsif !current_user.is_newbie
      flash[:error] = 'You are not allowed to see this step!'
      redirect_to root_path
    end
  end

  def assign_followers
    DefaultFollowerService.new(current_user).assign
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name,
                                 :avatar, :sex, :country, :birthdate, :biography)
  end
end
