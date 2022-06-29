class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :authenticate_user!

  def auth
    @user = User.create_from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = prepare_message
      sign_in_and_redirect(@user)
    else
      # session['devise.user_attributes'] = @user.attributes # What's that?
      redirect_to new_user_registration_path
    end
  end

  private
  def prepare_message
    if @user.is_newbie
      'Great, you are almost there'
    else
      'You logged in successfully'
    end
  end

  alias facebook auth
  alias twitter auth
  alias linkedin auth
  alias github auth
  alias passthru auth
  alias google_oauth2 auth
end
