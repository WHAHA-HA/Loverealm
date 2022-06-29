json.id message.id
json.body message.body
json.is_read message.sender_id === current_user.id || message.is_read
json.created_at message.created_at.to_i
json.updated_at message.updated_at.to_i
