class Dashboard::ContentsController < ApplicationController
  include PreparingHashTags

  before_action :set_content, only: [:update, :destroy]
  before_action :authenticate_user!, only: [:like, :dislike]

  respond_to :html, :json, :js

  def index
    @trending_tags = HashTag.trending_tags.limit(16)

    @contents = if params[:tag_id]
      Content.filter_by_tags(params[:tag_id]).order('created_at DESC')
    else
      Content.order('created_at DESC')
    end

    @contents = @contents.includes(:hash_tags, :user).page(params[:page])
    respond_to :js, :html
  end

  def new
    @displayed_user = current_user
    @story = Content.new
  end

  def show
    @content = Content.find(params[:id])
    @hash_tags_recommended_contents = Content.recommendations_by_hash_tags(current_user, @content)
    @popular_contents = Content.recommendations_by_popularity(current_user, @content)
    @recommended_stories = @hash_tags_recommended_contents.order('RANDOM()').limit(2).concat @popular_contents.order('RANDOM()').limit(3)
    @recommended_stories = @recommended_stories.uniq
  end

  def create
    @content = Content.new(content_params)
    @content.user_id = current_user.id
    @content.description.gsub!(/\r\n/, '<br/>') if @content.is_status?
    @content.hash_tags = prepare_hash_tags_for_story if @content.is_story?
    respond_to do |format|
      if @content.save
        format.js
        format.html { redirect_to dashboard_user_path(current_user) }
      elsif @content.is_story?
        @displayed_user = current_user
        format.html do
          @displayed_user = current_user
          @story = @content
          render :new
        end
      end
    end
  end

  def edit
    @displayed_user = current_user
    @content = Content.find(params[:id])
    @hash_tags = @content.hash_tags.pluck(:name).join(',')

    respond_to :js, :html
  end

  def update
    @content = Content.find(params[:id])
    @content.update_attributes(content_params)
    if @content.is_story?
      @content.hash_tags = prepare_hash_tags_for_story
      redirect_to [:dashboard, @content]
    else
      respond_with @content
    end
  end

  def update_picture
    @content = Content.find(params[:id])
    if @content.update_attributes(content_params)
      render :update_picture
    else
      render(json: { errors: content.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  def destroy
    @content = Content.find(params[:id])
    respond_to do |format|
      if @content.destroy
        format.js
        format.html { redirect_to :back, flash: { success: 'Successfuly deleted!' } }
      else
        format.js
        format.html { redirect_to :back, flash: { error: 'Content not deleted!' } }
      end
    end
  end

  def like
    @content = Content.find(params[:id])
    @content.liked_by current_user
    @content.notify_likes current_user
    respond_to do |format|
      format.js
      format.json { render json: { message: 'ok' } }
    end
  end

  def dislike
    @content = Content.find(params[:id])
    @content.unliked_by current_user
    respond_to do |format|
      format.js
      format.json { render json: { message: 'ok' } }
    end
  end

  private

  def prepare_hash_tags_for_story
    @list_of_tags = []
    params[:tags].split(',').each do |tag_name|
      tag = HashTag.find_by_name(tag_name)
      @list_of_tags << tag if tag.present?
    end
    @list_of_tags
  end

  def set_content
    @message = Content.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:description, :title, :image, :content_type, :tags, :bootsy_image_gallery_id)
  end
end
