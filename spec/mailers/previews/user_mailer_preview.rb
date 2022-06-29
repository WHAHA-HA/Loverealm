class UserMailerPreview < ActionMailer::Preview
  def notification_summary
    UserMailer.notification_summary(User.find(8))
  end
end
