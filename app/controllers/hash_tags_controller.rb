class HashTagsController < ApplicationController
  before_action :set_hash_tag, only: [:show, :edit, :update, :destroy]

  respond_to :json, :html

  def index
    @hash_tags = HashTag.all
    respond_with(@hash_tags)
  end

  def show
    respond_with(@hash_tag)
  end

  def new
    @hash_tag = HashTag.new
    respond_with(@hash_tag)
  end

  def edit
  end

  def create
    h = HashTag.find(params[:hash_tag][:id])

    current_user.hash_tags << h
    render json: current_user.hash_tags
  end

  def update
    @hash_tag.update(hash_tag_params)
    respond_with(@hash_tag)
  end

  def destroy
    current_user.hash_tags.destroy(@hash_tag)
    render json: { tags: current_user.hash_tags, status: 'OK' }
  end

  private

  def set_hash_tag
    @hash_tag = HashTag.find(params[:id])
  end

  def hash_tag_params
    params.require(:hash_tag).permit(:id, :name)
  end
end
