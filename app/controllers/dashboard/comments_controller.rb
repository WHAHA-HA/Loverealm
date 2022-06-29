class Dashboard::CommentsController < ApplicationController
  respond_to :json

  def index
    @content  = Content.find(params[:id])
    @comments = @content.comments.page(params[:page]).per(5)
    respond_to :js
  end

  def create
    @comment = Comment.create comment_params.merge(user: current_user,
                                                   content: Content.find(params[:content_id]))
    respond_to :js
  end

  def update
    @comment = Comment.find(params[:comment_id])
    @comment.update_attributes(comment_params)
    respond_with @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
