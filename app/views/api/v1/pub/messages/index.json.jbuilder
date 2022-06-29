json.number_of_messages @number_of_messages
json.messages @messages do |message|
  json.partial! 'api/v1/pub/messages/message', message: message
end