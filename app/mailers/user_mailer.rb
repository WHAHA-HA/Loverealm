class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def notification_summary(user)
    @user = user
    @notifications = @user.unread_notifications.limit(5)
    return unless @notifications.present?

    @relationship_notifications = @notifications.select do |n|
      n.key == "relationship.create"
    end

    email_with_name = %("#{@user.full_name}" <#{user.email}>)
    mail to: @user.email, subject: notification_summary_subject
  end

  def welcome_mentor(user)
    @mentor = user
    mail to: @mentor.email, subject: 'You are mentor now!'
  end

  def invitation_mail(user)
    @user = user
    mail to: @user.email, subject: 'LoveRealm (Christian social network) launches...'
  end

  def gmail_invitation(sender, receiver_email)
    @sender = sender
    mail to: receiver_email, subject: 'Join me on LoveRealm'
  end

  def we_miss_you(user)
    @user = user
    mail to: @user.email, subject: "We’ve missed you"
  end

  def popular_stories(user, contents)
    @user = user
    @contents = contents
    mail to: @user.email, subject: "Our most popular stories in the past week"
  end

  def mobile_app_promotion(user)
    @user = user
    mail to: @user.email, subject: "Dont miss out: the hottest way to connect with christians is here!"
  end

  def survey(user)
    @user = user
    mail to: @user.email, subject: "Help us improve LoveRealm"
  end

  private

  def notification_summary_subject
    path = 'views.user_mailer.notification_summary.subject'
    if @relationship_notifications.present?
      I18n.t("#{path}.follower_count", count: @relationship_notifications.count)

    else
      I18n.t("#{path}.notification_count", count: @notifications.count)
    end
  end
end
