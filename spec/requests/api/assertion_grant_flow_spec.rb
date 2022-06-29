require 'rails_helper'
require 'webmock/rspec'

describe 'Assertion grant flow', type: :request do
  describe 'POST /oauth/token' do
    let!(:application) { FactoryGirl.create(:application) }
    let!(:facebook_assertion) { SecureRandom.base64 }
    
    it 'responds with status 200 if there is facebook user with given token' do
      stub_request(:get, "https://graph.facebook.com/v2.3/me").
        with(:headers => {'Accept'=>'*/*', 'Authorization'=>"Bearer #{facebook_assertion}" }).
        to_return(:status => 200, :body => {
          id: "#{SecureRandom.random_number}",
          email: "truc.trac@example.com",
          first_name: "Иван",
          gender: "male",
          last_name: "Бишевац",
          name: "Иван Бишевац" }.to_json)

      post "/oauth/token", { grant_type: 'assertion', assertion: facebook_assertion, scope: 'full_access',
        provider: 'facebook', client_id: application.uid }

      expect(response.status).to eq 200
    end

    it 'creates new user with given email' do
      stub_request(:get, "https://graph.facebook.com/v2.3/me").
        with(:headers => {'Accept'=>'*/*', 'Authorization'=>"Bearer #{facebook_assertion}" }).
        to_return(:status => 200, :body => {
          id: "#{SecureRandom.random_number}",
          email: "truc.trac@example.com",
          first_name: "Иван",
          gender: "male",
          last_name: "Бишевац",
          name: "Иван Бишевац" }.to_json)

      expect {
        post "/oauth/token", { grant_type: 'assertion', assertion: facebook_assertion, scope: 'full_access',
          provider: 'facebook', client_id: application.uid }
      }.to change { User.count }.by(1)
    end

    it 'returns 401 if there is no facebook user with given assertion' do
      stub_request(:get, "https://graph.facebook.com/v2.3/me").
        with(:headers => {'Accept'=>'*/*', 'Authorization'=>"Bearer #{facebook_assertion}" }).
        to_return(:status => 401, :body => { error: {
          message: "Invalid OAuth access token.",
          type: "OAuthException",
          code: 190,
          fbtrace_id: "DsXVaxGu4z7"}}.to_json)

      post "/oauth/token", { grant_type: 'assertion', assertion: facebook_assertion, scope: 'full_access',
        provider: 'facebook', client_id: application.uid }

      expect(response.status).to eq 401
    end   
  end
end