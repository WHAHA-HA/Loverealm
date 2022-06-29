class Api::V1::BaseController < ActionController::Base
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session

  # before_action :authorize_pub!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def authorize_pub!
    doorkeeper_authorize! :full_access
  end

  # TODO: How to restrict mobile tokens to access other namespaces (like pub)?
  def authorize_mobile!
    doorkeeper_authorize! :full_access, :mobile
  end

  def current_user
    if doorkeeper_token
      if doorkeeper_token.resource_owner_id
        @current_user ||= User.find(doorkeeper_token.resource_owner_id)
      else
        @current_user = nil
      end
    else
      @current_user ||= User.find(session[:user_id])
    end
  end

  private

  def record_not_found(exception)
    render json: { errors: [exception.message] }, status: :not_found
  end
end
