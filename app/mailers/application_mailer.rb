class ApplicationMailer < ActionMailer::Base
  default from: %("LoveRealm" <noreply@loverealm.com>)
  layout 'mailer'
end
