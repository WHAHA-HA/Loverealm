class Api::V1::Pub::AppointmentsController < Api::V1::BaseController
  def create
    mentor_service = MentorService.new current_user, params[:mentor_id]
    @appointment = mentor_service.appointment
    @conversation = mentor_service.conversation
    if @appointment.persisted?
      render(:show, status: :created) && return
    else
      render(json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end
end
