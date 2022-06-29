require 'rails_helper'

describe OmniauthCallbacksController, type: :controller do
  describe 'GET #auth' do
    before do
      OmniAuth.config.test_mode = true
      request.env["devise.mapping"] = Devise.mappings[:user]
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid:'123545',
        info: {
          name: 'Test',
          email: 'foo.bar@example.com'
        },
        credentials: {
          token: '1234123412341234'
        }})

      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end

    it 'redirects to first step for successful login' do
      get :facebook
      
      expect(response).to redirect_to dashboard_welcome_first_path
    end

    it 'redirects to first step when user logs in with second provider' do
      get :facebook

      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid:'123545',
        info: {
          name: 'Test',
          email: 'foo.bar@example.com'
        },
        credentials: {
          token: '1234123412341234'
        }})
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]

      get :google_oauth2

      expect(response).to redirect_to dashboard_welcome_first_path
    end
  end
end
