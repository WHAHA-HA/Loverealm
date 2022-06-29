class InvitationMailService
  def initialize(user, emails)
    @user = user
    @emails = reject_registered_emails(emails)
  end

  def perform
    task = LongTasks::MassMailer.new(@user, @emails)
    Delayed::Job.enqueue(task, 0, 5.minutes.from_now)
  end

  private

  def reject_registered_emails(emails)
    emails - User.where(email: emails).pluck(:email)
  end
end
