class Api::V1::Mobile::UsersController < Api::V1::Pub::UsersController
  include MobileAuthorizer
end
