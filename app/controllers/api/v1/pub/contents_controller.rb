class Api::V1::Pub::ContentsController < Api::V1::BaseController
  before_action :set_content, except: :index

  def index
    @contents = Content.order('created_at DESC')
    if params[:tag_id]
      @contents = @contents.filter_by_tags(HashTag.where(id: params[:tag_id]))
    end
    @contents = @contents.page(params[:page]).per(params[:per_page])
  end

  def destroy
    @content.destroy
    head(:no_content)
  end

  def like
    @content.liked_by current_user
    @content.notify_likes current_user
    head(:created)
  end

  def dislike
    @content.unliked_by current_user
    head(:created)
  end

  private

  def set_content
    @content = Content.find(params[:id])
  end
end
