class AppointmentMailer < ApplicationMailer
  def notify_mentee(appointment)
    @appointment = appointment

    mail(to: @appointment.mentee.email, subject: 'You have new counseling session')
  end

  def notify_counsellor(appointment)
    @appointment = appointment

    mail(to: @appointment.mentor.email, subject: 'You have new counseling session')
  end
end
