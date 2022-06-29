module SharedVariables
  def messages_unread
    @unread_messages = current_user.messages.unread_messages.count
  end

  def suggested_users
    if current_user
      tags = current_user.hash_tags.pluck :id
      following_ids = current_user.following_ids
      @suggested_users = User.joins(:hash_tags).where('hash_tags.id IN (?)', tags).where.not('users.id = ?', current_user.id).where.not('users.id IN (?)', following_ids).completed_users.with_full_profile.limit(5).select('users.*, count(hash_tags)').group('users.id').order('count(hash_tags) desc')
    end
  end

  private

  def get_my_contents_count
    @my_contents_count = current_user.my_contents.count if user_signed_in?
  end
end
