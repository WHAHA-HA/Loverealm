json.id message.id
json.body message.body
json.receiver_id message.receiver_id
json.sender_id message.sender_id
json.is_read message.is_read
json.removed_at message.removed_at ? message.removed_at.to_i : message.removed_at
json.created_at message.created_at.to_i
json.updated_at message.updated_at.to_i
json.story_id message.story_id
