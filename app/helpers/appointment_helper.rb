module AppointmentHelper
  def connect_with_counsellor(appointment, mentor = nil, mentee = nil, conversation = nil)
    if appointment.present? && conversation.present?
      link_to "Let's talk", dashboard_conversation_path(conversation), class: 'btn btn-default counsellor-chat', method: :get
    else
      link_to "Let's talk", user_appointments_path(mentee, mentor_id: mentor.id), class: 'btn btn-default counsellor-chat', method: :post
    end
  end
end
