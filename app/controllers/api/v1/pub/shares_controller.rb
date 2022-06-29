class Api::V1::Pub::SharesController < Api::V1::BaseController
  before_action :set_content

  def destroy
    @share = Share.where(user: current_user, content: @content).first
    @share.destroy if @share
    head(:no_content)
  end

  def create
    Share.find_or_create_by(user: current_user, content: @content)
    head(:created)
  end

  private

  def set_content
    @content = Content.find(params[:content_id])
  end
end
