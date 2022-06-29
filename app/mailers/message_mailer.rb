class MessageMailer < ApplicationMailer
  def notify_receiver(message)
    @conversation = message.conversation
    @receiver = message.receiver
    @sender = message.sender

    mail(to: @receiver.email, subject: "#{@sender.full_name} sent you a new message")
  end
end
