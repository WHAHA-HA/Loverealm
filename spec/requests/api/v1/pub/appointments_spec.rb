require 'rails_helper'

describe 'api/v1/pub/appointments' do
  let!(:user1) { FactoryGirl.create(:user, is_newbie: false) }
  let!(:mentor) { FactoryGirl.create(:admin) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application, resource_owner_id: user1.id)
  end

  describe 'POST api/v1/pub/appointments' do
    it 'create appointment' do
      post "/api/v1/pub/users/#{user1.id}/appointments", mentor_id: mentor.id, access_token: doorkeeper_access_token.token

      expect(response.status).to eq 201
      expect(json).to have_key 'id'
      expect(json['mentee_id']).to eq user1.id
      expect(json['mentor_id']).to eq mentor.id
      expect(json['finished']).to eq false
      expect(json['mentor_conversation_id']).to eq 1
    end
  end
end
