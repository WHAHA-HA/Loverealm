class Api::V1::Mobile::StatusesController < Api::V1::Pub::StatusesController
  include MobileAuthorizer
end
