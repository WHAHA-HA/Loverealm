class InvitationSmsService
  def initialize(user, phone_numbers)
    @user = user
    @phone_numbers = phone_numbers
  end

  def perform
    task = LongTasks::MassSMS.new(@user, @phone_numbers)
    Delayed::Job.enqueue(task)
  end
end
