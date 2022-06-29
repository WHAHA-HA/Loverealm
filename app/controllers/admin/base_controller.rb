module Admin
  class BaseController < ApplicationController
    before_action :admin_authenticate

    layout 'admin'

    private

    def admin_authenticate
      unless user_signed_in? || current_user.admin?
        flash[:error] = 'You are not authorized to see this page!'
        redirect_to root_path
      end
    end
  end
end
