namespace :mailer do
  desc 'Send notification summary'
  task notification_summary: :environment do
    date = 3.days.ago
    users = User.newsletter_subscribers.where(current_sign_in_at: date.midnight..date.end_of_day)
    users.find_each do |user|
      UserMailer.notification_summary(user).deliver
    end
  end

  desc "Send 'we miss you' email"
  task we_miss_you_email: :environment do
    if Time.now.day == 7
      date = 1.month.ago
      users = User.newsletter_subscribers.where('current_sign_in_at < ?', date.end_of_day)
      users.find_each do |user|
        UserMailer.we_miss_you(user).deliver
      end
    end
  end

  desc 'Send most popular weekly topics'
  task most_popular_weekly_topics: :environment do
    if Time.now.tuesday?
      contents = Content.popularity_on_weekly_basis
      users = User.newsletter_subscribers
      users.find_each do |user|
        UserMailer.popular_stories(user, contents).deliver
      end
    end
  end

  desc 'Send most popular monthly topics'
  task most_popular_monthly_topics: :environment do
    if (Time.now.month % 3 != 0) && Time.now.day == 1
      contents = Content.popularity_on_monthly_basis
      users = User.newsletter_subscribers
      users.find_each do |user|
        UserMailer.popular_stories(user, contents).deliver
      end
    end
  end

  desc 'Send most popular quarterly topics'
  task most_popular_quarterly_topics: :environment do
    if Time.now.day == 1 && (Time.now.month % 3 == 0)
      contents = Content.popularity_on_quarterly_basis
      users = User.newsletter_subscribers
      users.find_each do |user|
        UserMailer.popular_stories(user, contents).deliver
      end
    end
  end


  desc 'Invite all users to new app'
  task email_invitation: :environment do
    User.find_each do |user|
      p "Sending email to #{user.email}"
      UserMailer.invitation_mail(user).deliver_now
    end
  end

  desc 'Promote Mobile App'
  task email_promoting_mobile_app: :environment do
    User.find_each do |user|
      p "Sending email to #{user.email}"
      UserMailer.mobile_app_promotion(user).deliver_now
    end
  end
end
