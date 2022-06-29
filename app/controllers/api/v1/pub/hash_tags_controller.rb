class Api::V1::Pub::HashTagsController < Api::V1::BaseController
  def index
    @hash_tags = HashTag.all
  end

  def autocomplete_hash_tags
    @hash_tags = HashTag.where('name like ?', "%#{params[:term]}%").limit(5)

    render :index
  end
end
