json.id @conversation.id
json.user do
  json.partial! 'api/v1/pub/users/simple_user', user: User.find(@conversation.get_participant(current_user))
end
json.number_of_messages @messages.count
json.messages @messages do |message|
  json.partial! 'api/v1/pub/messages/message', message: message
end