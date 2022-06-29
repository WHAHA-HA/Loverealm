class Mentorship < ActiveRecord::Base
  belongs_to :hash_tag
  belongs_to :mentor, class_name: 'User', foreign_key: :mentor_id
end
