class Report < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :user

  default_scope -> { where(reviewed: false).order('created_at DESC') }

  validates :description, presence: true
  validates :target_type, presence: true, inclusion: { in: %w(User Content Comment) }
  validates :target_id, presence: true
end
