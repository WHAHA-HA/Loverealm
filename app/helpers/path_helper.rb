module PathHelper
  def home_path
    user_signed_in? ? dashboard_user_path(current_user) : root_path
  end
end
