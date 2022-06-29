module MobileAuthorizer
  extend ActiveSupport::Concern

  included do
    skip_before_action :authorize_pub!
    before_action :authorize_mobile!
  end
end
