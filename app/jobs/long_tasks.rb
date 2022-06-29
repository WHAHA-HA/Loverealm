class LongTasks
  MassMailer = Struct.new(:sender, :receivers) do
    def perform
      receivers.each do |receiver|
        UserMailer.gmail_invitation(sender, receiver).deliver
      end
    end

    def max_attempts
      3
    end
  end

  MassSMS = Struct.new(:sender, :phone_numbers) do
    def perform
      phone_numbers.each do |phone_number|
        InfobipService.send_invitation_sms phone_number, sender
      end
    end

    def max_attempts
      3
    end
  end

  DailyDevotionNotification = Struct.new(:story) do
    def perform
      User.find_each(batch_size: 100000) do |user|
        CreateMessageService.new(user.id, story.user_id).send_daily_devotion_message(story) unless user.id == story.user_id
      end
    end

    def max_attempts
      3
    end
  end
end
