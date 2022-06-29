class AppointmentsController < ApplicationController
  def create
    mentor_service = MentorService.new current_user, params[:mentor_id]
    @appointment = mentor_service.appointment
    if @appointment.persisted?
      redirect_to dashboard_conversation_path(mentor_service.conversation), notice: 'Welcome, your session is started here.'
    else
      redirect_to :back, flash: { error: @appointment.errors.full_messages[0].to_s }
    end
  end
end
