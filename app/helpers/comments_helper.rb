module CommentsHelper
  def comment_owner(owner)
    link_to owner.full_name, dashboard_profile_path(owner)
  end
end
