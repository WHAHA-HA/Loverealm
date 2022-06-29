json.array!(@messages) do |message|
  json.extract! message, :id, :subject, :body, :receiver_id, :sender_id
  json.sent_at message.created_at < (DateTime.now - 1.days) ? message.created_at.strftime("%d/%m/%Y") : message.created_at.strftime("%I:%M %p")
  json.direction message.sender_id == current_user.id ? "" : "incoming"
  json.avatar_url message.sender.avatar_url == "missing.jpg" ? asset_path("missing.jpg") : message.sender.avatar_url
end
