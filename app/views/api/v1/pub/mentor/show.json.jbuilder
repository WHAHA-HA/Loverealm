json.partial! 'api/v1/pub/users/simple_user', user: @mentor
if @conversation.present?
  json.mentor_conversation_id @conversation.id
end
