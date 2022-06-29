class Api::V1::Pub::RelationshipsController < Api::V1::BaseController
  def follow
    followed_user = User.find(params[:followed_id])

    Relationship.create(follower: current_user, followed: followed_user)

    head(status: :created) && return
  end

  def unfollow
    followed_user = User.find(params[:followed_id])
    relationship = Relationship.find_by!(follower: current_user, followed: followed_user)

    relationship.destroy

    head :no_content
  end
end
