json.number_of_unread_messages current_user.received_messages.unread_messages.count
json.number_of_unread_notifications current_user.unread_notification_count
json.number_of_followers current_user.num_of_followers
json.number_of_followings current_user.following.count
json.number_of_posts current_user.contents.count

json.contents @contents do |content|
  json.partial! 'api/v1/pub/contents/content', content: content
  if content.try(:feed_item_type) == 'share' && content.try(:feed_item_shared_by)
    json.shared_by do
      json.partial! 'api/v1/pub/users/simple_user', user: User.find(content.feed_item_shared_by)
    end
  end
end
