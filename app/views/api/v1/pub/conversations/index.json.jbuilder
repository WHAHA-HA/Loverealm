json.array! @conversations do |conversation|
  json.id conversation.id
  json.user do
    json.partial! 'api/v1/pub/users/simple_user', user: User.find(conversation.get_participant(current_user))
  end
  json.number_of_messages conversation.messages.count
  json.last_message do
    json.partial! 'api/v1/pub/messages/message_simple', message: conversation.messages.last
  end
end
