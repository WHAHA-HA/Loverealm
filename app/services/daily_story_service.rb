class DailyStoryService
  def initialize(story)
    @story = story
  end

  def perform
    task = LongTasks::DailyDevotionNotification.new(@story)
    run_at_time = ((@story.publishing_at + 7.hours - Time.now)/1.hour).round
    Delayed::Job.enqueue(task, 0, run_at_time.hours.from_now)
  end
end
