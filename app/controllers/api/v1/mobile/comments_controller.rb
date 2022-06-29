class Api::V1::Mobile::CommentsController < Api::V1::Pub::CommentsController
  include MobileAuthorizer
end
