class Api::V1::Pub::MentorController < Api::V1::BaseController
  def show
    @mentor = GetMentorService.new.call(current_user)

    if @mentor
      @appointment = Appointment.where(mentor_id: @mentor.id,
                                       mentee_id: current_user.id).take
      @conversation = @appointment.conversation if @appointment
      render :show
    else
      head :no_content
    end
  end
end
