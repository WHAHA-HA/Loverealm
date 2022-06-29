class DailyDevotionMessenger
  def self.message_all_users(story)
    task = LongTasks::DailyDevotionNotification.new(story)
    Delayed::Job.enqueue(task, 0, 5.minutes.from_now)
  end
end
