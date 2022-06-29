class Appointment < ActiveRecord::Base
  belongs_to :mentee, class_name: 'User', foreign_key: 'mentee_id'
  belongs_to :mentor, class_name: 'User', foreign_key: 'mentor_id'

  has_one :conversation

  after_save :email_participients

  validates_uniqueness_of :mentor_id, scope: [:mentee_id], message: 'and appointment already exists.'

  private

  def email_participients
    AppointmentMailer.notify_mentee(self).deliver_now
    AppointmentMailer.notify_counsellor(self).deliver_now
  end
end
