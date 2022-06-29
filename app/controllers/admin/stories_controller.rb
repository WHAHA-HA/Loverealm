module Admin
  class StoriesController < BaseController
    include PreparingHashTags

    def index
      @stories = Content.fetch_daily_devotions.page(params[:page])
    end

    def new
      @story = Content.new
    end

    def create
      @story = Content.new(story_params.merge(content_type: 'daily_story', user_id: current_user.id))
      @story.hash_tags = prepare_hash_tags_for_story
      Content.public_activity_off
      if @story.save
        DailyStoryService.new(@story).perform
        redirect_to admin_stories_path, flash: { success: "Your story will be published" }
      else
        render :new
      end
    end

    def edit
      @story = Content.find(params[:id])
      @hash_tags = @story.hash_tags.pluck(:name).join(',')
    end

  def update
    @story = Content.find(params[:id])
    if @story.update_attributes(story_params)
      @story.hash_tags = prepare_hash_tags_for_story
      redirect_to admin_stories_path, flash: { success: "Successfully updated daily story" }
    else
      respond_with @story
    end
  end


    private
    def story_params
      attrs = params.require(:content).permit(:description, :title, :image, :tags, :bootsy_image_gallery_id, :publishing_at)

      if attrs[:publishing_at].present?
        attrs[:publishing_at] = Date.strptime(attrs[:publishing_at], '%m/%d/%Y')
      end

      attrs
    end
  end
end
