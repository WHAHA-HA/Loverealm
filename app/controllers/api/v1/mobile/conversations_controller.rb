class Api::V1::Mobile::ConversationsController < Api::V1::Pub::ConversationsController
  include MobileAuthorizer
end
