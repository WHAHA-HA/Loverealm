class Api::V1::Pub::UserHashTagsController < Api::V1::BaseController
  before_action :set_user
  before_action :set_hash_tags, only: :create

  def index
    @hash_tags = @user.hash_tags
  end

  def create
    unless current_user.id == @user.id
      head(status: 403) && return
    end
    current_user.hash_tags = [] if @hash_tags.present?

    @hash_tags.each do |hash_tag|
      HashTagsUser.find_or_create_by(user_id: @user.id, hash_tag_id: hash_tag.id)
    end
    head(status: 201) && return
  end

  private

  def set_hash_tags
    @hash_tags ||= [].tap do |tags|
      params.fetch(:hash_tag_ids, []).each { |id| tags << HashTag.find(id) }
      params.fetch(:hash_tag_names, []).each do |tag_name|
        tags << HashTag.find_or_create_by(name: tag_name)
      end
    end
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
