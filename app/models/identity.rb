class Identity < ActiveRecord::Base
  belongs_to :user

  validates :user, :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: [:user_id, :provider] }

  def self.find_or_create_from_omniauth(user, auth)
    unless identity = Identity.find_by(user: user, uid: auth.uid, provider: auth.provider)
      identity = Identity.create!(user: user, uid: auth.uid, provider: auth.provider, oauth_token: auth['credentials']['token'])
    else
      # if old token expired update with new one
      identity.update(oauth_token: auth['credentials']['token']) unless identity.oauth_token == auth['credentials']['token']
    end

    identity
  end
end