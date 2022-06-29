class Api::V1::Pub::InvitationsController  < Api::V1::BaseController
  def create
    if params[:phone_numbers].present?
      registered_numbers = User.where(phone_number: params[:phone_numbers])
                               .pluck(:phone_number)

      invited_phone_numbers = PhoneNumberInvitation
        .where(phone_number: params[:phone_numbers])
        .where('updated_at > ?', 2.days.ago)
        .pluck(:phone_number)

      phone_numbers = params[:phone_numbers] - registered_numbers - invited_phone_numbers
      if phone_numbers.present?
        update_phone_numbers!(current_user, phone_numbers)
        InvitationSmsService.new(current_user, phone_numbers).perform
      end
    end

    if params[:emails].present?
      InvitationMailService.new(current_user, params[:emails]).perform
    end

    head :created
  end

  private

  def update_phone_numbers!(sender, phone_numbers)
    phone_numbers.each do |phone_number|
      invited_number = PhoneNumberInvitation.find_or_initialize_by({
        user: sender,
        phone_number: phone_number
      })
      invited_number.persisted? ? invited_number.touch : invited_number.save
    end
  end
end
