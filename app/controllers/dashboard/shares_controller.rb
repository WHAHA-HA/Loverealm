class Dashboard::SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_content
  respond_to :js

  def create
    @share = Share.find_or_create_by(content: @content, user: current_user)
  end

  def destroy_by_content_id
    @share = Share.where(user: current_user, content: @content).first
    @share.destroy
  end

  private

  def set_content
    @content = Content.find(params[:content_id])
  end
end
