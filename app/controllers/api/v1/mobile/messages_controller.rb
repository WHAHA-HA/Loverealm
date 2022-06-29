class Api::V1::Mobile::MessagesController < Api::V1::Pub::MessagesController
  include MobileAuthorizer
end
