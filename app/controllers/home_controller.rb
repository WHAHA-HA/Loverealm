class HomeController < ApplicationController
  before_filter :require_welcome_steps
  def index
    if user_signed_in? && !current_user.banned?
      redirect_to dashboard_user_path(current_user)
    end
  end

  def login
  end

  def search
  end

  def searchresult
  end

  def about_us
  end

  def about_jesus
  end

  def careers
  end

  def privacy_policy
  end

  def terms
  end

  def help
  end

  def press_new
  end

  def feedback
  end

  def beta_notification
  end

  def mobile_app
  end

  def dl
    if browser.platform.android?
      redirect_to 'https://play.google.com/store/apps/details?id=com.loverealm.loverealmmobile'
    else
      redirect_to root_path
    end
  end

  private

  def require_welcome_steps
    if current_user && current_user.is_newbie
      flash[:error] = 'Please finish your welcome steps!'
      redirect_to dashboard_welcome_first_path
    end
  end
end
