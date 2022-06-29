class Feedback < ActiveRecord::Base
  belongs_to :user

  scope :unchecked, -> { where.not(checked: true) }
end
