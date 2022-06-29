class PostStatus < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :likes

  def self.find_for_user(user)
    where(user_id: user.id).first
  end
end
