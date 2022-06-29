class Api::V1::Pub::StatusesController < Api::V1::BaseController
  def show
    @status = Content.find(params[:id])
  end

  def create
    @status = Content.new(status_params.merge(user_id: current_user.id, content_type: 'status'))

    if @status.save
      render(:show, status: :created) && return
    else
      render(json: { errors: @status.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  def update
    @status = Content.find(params[:id])

    if @status.update_attributes(status_params)
      render(:show, status: :ok) && return
    else
      render(json: { errors: @status.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  private

  def status_params
    params.permit(:description)
  end
end
