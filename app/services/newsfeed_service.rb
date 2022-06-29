class NewsfeedService
  def initialize user
    @user = user
    @following_user_ids = @user.following.map(&:id) << @user.id
  end

  def recent_content
    query = [shared_content_sql, regular_content_sql].join(' UNION ')
    Content.from("(#{query}) as contents")
     .distinct
     .order('contents.feed_item_date DESC')
  end

  private

  def shared_content_sql
    Content.select("contents.*,
        shares.created_at as feed_item_date,
        'share' as feed_item_type,
        shares.user_id as feed_item_shared_by")
     .joins(:shares)
     .where('shares.user_id' => @following_user_ids)
     .to_sql
  end

  def regular_content_sql
    content_selection = Content.select("contents.*,
                                contents.created_at as feed_item_date,
                                cast('regular' as text) as feed_item_type,
                                cast(NULL as int)  as feed_item_shared_by")

    follower_content_sql = content_selection
      .from("(#{Relationship.where(follower_id: @user.id).to_sql}) as relationships")
      .joins("INNER JOIN contents ON contents.user_id = relationships.followed_id AND contents.created_at > relationships.created_at AND contents.content_type <> 'daily_story'")
      .to_sql

    user_content_sql = content_selection.where(user_id: @user.id)
                        .where.not(content_type: 'daily_story')
                        .to_sql

    [follower_content_sql, user_content_sql].join(' UNION ')
  end
end
