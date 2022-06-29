module WebAuthorizer
  extend ActiveSupport::Concern

  included do
    skip_before_action :authorize_pub!
    before_action :authenticate_user!
  end
end
