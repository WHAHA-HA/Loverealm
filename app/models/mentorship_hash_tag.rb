class MentorshipHashTag < HashTag
  belongs_to :mentor, -> { where(role_id: Role.find_by_name('mentor').id) }, class_name: 'User', foreign_key: 'mentor_id'

  validates :name, uniqueness: { scope: :mentor_id }
  validates_uniqueness_of :mentor_id
end
