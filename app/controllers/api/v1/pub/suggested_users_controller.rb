class Api::V1::Pub::SuggestedUsersController < Api::V1::BaseController
  def index
    @suggested_users = User.suggested_users(current_user)
  end
end
