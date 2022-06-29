require 'rails_helper'
require 'webmock/rspec'

RSpec.describe CreateUserFromFacebookService do
  let!(:application) { FactoryGirl.create(:application) }
  let!(:facebook_assertion) { SecureRandom.base64 }

  describe '#call' do
    it 'creates user if there is facebook user with given token' do
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
        CreateUserFromFacebookService.new.call(facebook_assertion)
      }.to change { User.count }.by(1)
    end

    it 'does not create user if there is no facebook user with given token' do
      stub_request(:get, "https://graph.facebook.com/v2.3/me").
        with(:headers => {'Accept'=>'*/*', 'Authorization'=>"Bearer #{facebook_assertion}" }).
        to_return(:status => 401, :body => { error: {
          message: "Invalid OAuth access token.",
          type: "OAuthException",
          code: 190,
          fbtrace_id: "DsXVaxGu4z7"}}.to_json)

      expect {
        CreateUserFromFacebookService.new.call(facebook_assertion)
      }.not_to change { User.count }
    end
  end
end