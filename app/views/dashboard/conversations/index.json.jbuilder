
json.array!(@conversations) do |conversation|
  receiver = User.find(conversation.get_participant(current_user))
  json.extract! conversation, :id
  json.unread_count current_user.received_messages.unread_messages.for_conversation(conversation.id).count
  json.name receiver.present? ? (receiver.first_name.present? ? receiver.first_name : "") + " " + (receiver.last_name.present? ? receiver.last_name : "") : "Anonymous"
  json.url User.find(conversation.get_participant(current_user)).avatar_url == "missing.jpg" ? asset_path("missing.jpg") : User.find(conversation.get_participant(current_user)).avatar_url
end
