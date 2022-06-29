require 'rails_helper'

describe 'api/v1/pub/mentor' do
  let!(:user1) { FactoryGirl.create(:user, is_newbie: false) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:conversation) { FactoryGirl.create(:conversation, participants: [user1.id, user2.id]) }
  let!(:appointment) { FactoryGirl.create(:appointment, mentee: user1, mentor: user2, conversation: conversation) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application, resource_owner_id: user1.id)
  end

  describe 'GET api/v1/pub/mentor' do
    it 'returns status 200' do
      get '/api/v1/pub/mentor', access_token: doorkeeper_access_token.token

      expect(response.status).to eq 200
    end

    it 'contains mentor fields' do
      get '/api/v1/pub/mentor', access_token: doorkeeper_access_token.token

      expect(json['id']).to eq user2.id
      expect(json['full_name']).to eq user2.full_name
      expect(json['avatar_url']).to eq user2.avatar.url
      expect(json['following']).to eq false
      expect(json['mentor_conversation_id']).to eq 1
    end

    it 'returns empty body with only headers and status 204 if there is no mentor for current user' do
      appointment.destroy

      get '/api/v1/pub/mentor', access_token: doorkeeper_access_token.token

      expect(response.status).to eq 204
    end
  end
end
