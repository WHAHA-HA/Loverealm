class Dashboard::InvitesController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    if params[:emails].blank?
      redirect_to :back, notice: "You didn't check any email for invitation!"
    else
      InvitationMailService.new(current_user, params[:emails]).perform
      redirect_to :back, notice: 'Your invitations are sent!'
    end
  end
end
