class Api::V1::Pub::CommentsController < Api::V1::BaseController
  def create
    @comment = Comment.new(comment_params_for_create.merge(user_id: current_user.id))

    if @comment.save
      render(:show, status: :created) && return
    else
      render(json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params_for_update)
      render(:show, status: :ok) && return
    else
      render(json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  private

  def comment_params_for_create
    params.permit(:body, :content_id)
  end

  def comment_params_for_update
    params.permit(:body)
  end
end
