module MessagesHelper
  def get_last_message_from(user)
    message = {}
    if user.key? :sender
      message[:message] = Message.where('receiver_id = ? and sender_id = ?', current_user.id, user[:sender]).order('created_at DESC')[0]
    else
      message[:message] = Message.where('receiver_id = ? and sender_id = ?', user[:receiver], current_user.id).order('created_at DESC')[0]
    end
    message[:user] = message[:message].send(user.keys[0])

    message
  end

  def print_name(user)
    if user.eql? current_user
      'You'
    else
      user.full_name
    end
  end
end
