class LikesController < ApplicationController
  before_action :set_like, only: [:destroy]
  before_action :find_existing_like, only: [:create]
  respond_to :json

  def show
  end

  def create
    @like = Like.new(like_params)
    @like.user_id = current_user.id
    if !@existing_like.present?
      @like.save
      respond_with(@like)
    else
      @existing_like.update_attributes(down: @existing_like.up, up: @existing_like.down)
      respond_with(@existing_like)
    end
  end

  def destroy
    @like.destroy
    respond_with(@like)
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def find_existing_like
    @existing_like = Like.where(user_id: current_user.id, content_id: like_params[:content_id]).take
  end

  def like_params
    params.require(:like).permit(:content_id)
  end
end
