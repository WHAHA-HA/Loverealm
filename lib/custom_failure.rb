class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_message == :unconfirmed
      new_user_session_path(confirmation_required: true)
    else
      super
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
