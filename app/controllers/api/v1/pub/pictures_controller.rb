class Api::V1::Pub::PicturesController < Api::V1::BaseController
  before_filter :check_image_presence, only: [:create]

  def show
    @picture = Content.find(params[:id])
  end

  def create
    @picture = Content.new(picture_params.merge(user_id: current_user.id, content_type: 'image'))

    @picture.set_image(params[:image])

    if @picture.save
      render(:show, status: :created) && return
    else
      render(json: { errors: @picture.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  def update
    @picture = Content.find(params[:id])

    if params[:image].present?
      @picture.set_image(params[:image])
    end

    if @picture.update_attributes(picture_params)
      render(:show, status: :ok) && return
    else
      render(json: { errors: @picture.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  private

  def check_image_presence
    unless params[:image]
      render(json: { errors: "Image can't be blank" }, status: :unprocessable_entity) && return
    end
  end

  def picture_params
    params.permit(:description)
  end
end
