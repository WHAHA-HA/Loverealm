class Api::V1::Mobile::SuggestedUsersController < Api::V1::Pub::SuggestedUsersController
  include MobileAuthorizer
end
