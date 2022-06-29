class MobileToken < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :device_token, :fcm_token, presence: true
end
