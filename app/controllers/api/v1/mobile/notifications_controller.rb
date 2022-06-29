class Api::V1::Mobile::NotificationsController < Api::V1::Pub::NotificationsController
  include MobileAuthorizer
end
