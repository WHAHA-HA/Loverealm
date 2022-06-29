class Api::V1::Pub::PasswordsController  < Api::V1::BaseController
  def create
    @user = User.find_by_email(params[:email])
    if @user.present?
      @user.send_reset_password_instructions
      head(:created) && return
    else
      head(:unprocessable_entity) && return
    end
  end

  def update
    @user = User.reset_password_by_token password_params
    if @user.errors.any?
      render(json: { errors: @user.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  def password_params
    params.permit(:reset_password_token, :password, :password_confirmation)
  end
end
