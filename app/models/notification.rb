class Notification
  class << self
    def for_user(user)
      query = [
        content_activities_query(user),
        relationship_activities_query(user),
        comment_activities_query(user)
      ].join(' UNION ')

      @activities = PublicActivity::Activity.from("(#{query}) as activities")
                                            .order('activities.created_at DESC')
    end

    def content_activities_query(user)
      PublicActivity::Activity.includes(:owner)
                              .where(owner_id: user.following_ids, owner_type: 'User', trackable_type: 'Content')
                              .joins('join relationships on owner_id = relationships.followed_id')
                              .where('relationships.created_at < activities.created_at')
                              .where('relationships.follower_id = ?', user.id)
                              .to_sql
    end

    def relationship_activities_query(user)
      PublicActivity::Activity.includes(:owner)
                              .where(trackable_type: 'Relationship')
                              .joins('join relationships on relationships.follower_id = recipient_id AND relationships.followed_id = owner_id')
                              .where('activities.owner_id = ?', user.id)
                              .where('activities.recipient_id <> ?', user.id)
                              .to_sql
    end

    def comment_activities_query(user)
      sub_query = <<-SQL
        SELECT DISTINCT contents.id FROM "contents"
        JOIN comments ON contents.id = comments.content_id AND comments.user_id = :user_id
        WHERE contents.user_id != :user_id
      SQL

      PublicActivity::Activity.includes(:owner)
                              .where.not(owner_id: user.id).where(trackable_type: 'Comment')
                              .joins('join comments on trackable_id = comments.id')
                              .joins('join contents on comments.content_id = contents.id')
                              .where("contents.user_id = :user_id OR contents.id IN (#{sub_query.squish})", user_id: user.id)
                              .to_sql
    end
  end
end
