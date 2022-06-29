class GetMentorService
  def call(user)
    Appointment.joins(mentor: :role).where(mentee_id: user.id).where('roles.name = ?', :mentor).take.try(:mentor) ||
    Mentorship.where('hash_tag_id in (?)', user.hash_tags.pluck(:id)).order('RANDOM()').map(&:mentor).first ||
    User.default_mentor
  end
end
