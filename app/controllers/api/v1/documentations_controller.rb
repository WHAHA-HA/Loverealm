class Api::V1::DocumentationsController < Api::V1::BaseController
  skip_before_action :authorize_pub!

  def index
  end
end
