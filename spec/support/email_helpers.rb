module Support
  module EmailHelpers
    def find_all_emails_with_subject(subject)
      ActionMailer::Base.deliveries.select do |mail|
        mail.subject == subject
      end
    end

    def clear_all_emails
      ActionMailer::Base.deliveries = []
    end
  end
end
