require 'rails_helper'

describe 'api/v1/pub/passwords' do
  let!(:user) { FactoryGirl.create(:user) }

  describe 'POST api/v1/pub/user/password' do
    it 'create reset password token' do
      post "/api/v1/pub/users/password", email: user.email

      expect(response.status).to eq 201
      expect(user.reload.reset_password_token).to_not be nil
    end

    it 'returns 422 status if email is not specified' do
      post "/api/v1/pub/users/password"

      expect(response.status).to eq 422
    end
  end

  describe 'POST api/v1/pub/user/password' do
    it 'update user password' do
      encrypted_password = user.encrypted_password
      token = Devise.token_generator.digest(user, :reset_password_token, 123)
      user.update reset_password_token: token, reset_password_sent_at: Time.now
      put "/api/v1/pub/users/password", {
        reset_password_token: 123,
        password: 123123,
        password_confirmation: 123123
      }

      expect(response.status).to eq 200
      expect(user.reload.encrypted_password).to_not eq encrypted_password
    end
  end
end
