class Api::V1::Mobile::InvitationsController < Api::V1::Pub::InvitationsController
  include MobileAuthorizer
end
