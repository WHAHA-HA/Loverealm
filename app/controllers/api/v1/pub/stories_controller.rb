class Api::V1::Pub::StoriesController < Api::V1::BaseController
  before_filter :check_image_presence, only: [:create]

  def show
    @story = Content.find(params[:id])
  end

  def create
    @story = Content.new(story_params.merge(user_id: current_user.id, content_type: 'story'))

    @story.set_image(params[:image])

    if @story.save
      if params[:hash_tag_ids].present?
        params[:hash_tag_ids].each do |hash_tag_id|
          ContentsHashTag.create!(content: @story, hash_tag_id: hash_tag_id)
        end
      end
      render(:show, status: :created) && return
    else
      render(json: { errors: @story.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  def update
    @story = Content.find(params[:id])

    if params[:image].present?
      @story.set_image(params[:image])
    end

    if @story.update_attributes(story_params)
      render(:show, status: :ok) && return
    else
      render(json: { errors: @story.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  private

  def check_image_presence
    unless params[:image]
      render(json: { errors: "Image can't be blank" }, status: :unprocessable_entity) && return
    end
  end

  def story_params
    params.permit(:title, :description)
  end
end
