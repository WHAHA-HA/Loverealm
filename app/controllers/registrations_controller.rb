class RegistrationsController < Devise::RegistrationsController
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: dashboard_user_path(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmations)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :location, :biography, :sex, :country, :birthdate, :avatar, :is_newbie)
  end

  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path(track_conversion: true) : "/?track_conversion=true"
  end
end
