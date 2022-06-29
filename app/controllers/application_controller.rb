class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :get_my_contents_count, except: [:update]
  before_action :set_meta_tags
  before_filter :store_current_location
  before_action :ensure_domain if Rails.env.production?

  private
  def store_current_location
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        request.path != "/users/auth/google_oauth2/callback" &&
        request.path != "/users/auth/facebook/callback" &&
        !request.xhr?)
      session[:previous_url] = request.fullpath
    end
  end

  include SharedVariables
  include PublicActivity::StoreController

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to home_path, alert: exception.message
  end

  protected

  def after_sign_in_path_for(resource)
    resource.is_newbie ? dashboard_welcome_first_path : (session[:previous_url] || dashboard_user_path(resource))
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:user_name, :email, :password, :password_confirmation, :image) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :nick, :location, :biography, :sex, :country, :birthdate, :avatar, :password, :password_confirmation) }
  end

  private

  def ensure_domain
    redirected_domain = 'www.loverealm.com'
    allowed_domains = ['www.loverealm.com']
    if !(allowed_domains.include? request.host)
      new_url = "#{request.protocol}#{redirected_domain}#{request.fullpath}"
      redirect_to new_url, status: :moved_permanently
    end
  end

  def hide_header
    @hide_header = true
  end

  def set_meta_tags
    @page_title = tv('.title', default: 'Christian Social Network')
    @page_description = tv('.description', default: 'LoveRealm - Christian Social Network')
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def home_path
    user_signed_in? ? dashboard_user_path(current_user) : root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    promo_mobile_app_path
  end
end
