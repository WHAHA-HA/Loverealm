class HashTagsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :hash_tag

  validates :hash_tag, presence: true, uniqueness: { scope: :user }
  validates :user, presence: true
end
