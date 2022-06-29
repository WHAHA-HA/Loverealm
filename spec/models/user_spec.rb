require 'rails_helper'

describe User do
  describe '.create_from_omniauth' do
    it 'creates user if one does not exist' do
      auth_params = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid:'123545',
        info: {
          name: 'Test',
          email: 'foo.bar@example.com'
        },
        credentials: {
          token: '1234123412341234'
        }
      })

      expect {
        User.create_from_omniauth(auth_params)
      }.to change{ User.count }.by(1)
    end

    it 'creates new identity if one does not exist' do
      user = FactoryGirl.create(:user)
      auth_params = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid:'123545',
        info: {
          name: user.full_name,
          email: user.email
        },
        credentials: {
          token: '1234123412341234'
        }
      })

      expect {
        User.create_from_omniauth(auth_params)
      }.to change{ Identity.count }.by(1)
    end

    it 'creates new identity if one does not exist' do
      user = FactoryGirl.create(:user)
      identity = FactoryGirl.create(:identity, user: user)

      auth_params = OmniAuth::AuthHash.new({
        provider: identity.provider,
        uid: identity.uid,
        info: {
          name: user.full_name,
          email: user.email
        },
        credentials: {
          token: '1234123412341234'
        }
      })

      expect {
        User.create_from_omniauth(auth_params)
      }.not_to change{ Identity.count }
    end
  end
end
