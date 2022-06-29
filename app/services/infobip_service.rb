class InfobipService
  def self.send_invitation_sms phone_number, user
    sms = OneApi::SMSRequest.new
    sms.sender_name =  user.full_name.gsub(/\s+/, "")#I18n.translate('sms.sender_name')
    sms.sender_address = user.full_name.gsub(/\s+/, "")#I18n.translate('sms.sender_name')
    sms.address = phone_number.gsub(/[\+\s]+/, '')
    sms.message = I18n.translate('sms.message.invitation', username: user.full_name)
    sms_logger.info("Send invitation sms to ******#{phone_number.to_s[-5, 5]}. Requester user id: #{user.id}.")
    sms_client.send_sms(sms)
  end

  def self.sms_client
    @sms_client ||= begin
      unless ENV['LR_INFOBIP_USERNAME'] && ENV['LR_INFOBIP_PASSWORD']
        raise "Infobip credentials are missing"
      end

      OneApi::SmsClient.new(ENV['LR_INFOBIP_USERNAME'], ENV['LR_INFOBIP_PASSWORD'])
    end
  end

  def self.sms_logger
    @sms_logger ||= Logger.new("#{Rails.root}/log/sms.log")
  end
end
