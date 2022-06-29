require 'rails_helper'

describe 'api/v1/pub/reports' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application,
                                                 resource_owner_id: user.id)
  end

  let!(:user2) { FactoryGirl.create(:user) }
  let!(:status) { FactoryGirl.create(:status, user: user2) }
  let!(:description) { 'This contains bad words' }
  let!(:target_type) { 'content' }
  let!(:target_id) { status.id }

  describe 'POST api/v1/pub/stories' do
    it 'returns status 201 for successful create' do
      post '/api/v1/pub/reports', access_token: doorkeeper_access_token.token, description: description,
                                  target_type: target_type, target_id: target_id

      expect(response.status).to eq 201
    end

    it 'returns 422 for errors in saving' do
      post '/api/v1/pub/reports', access_token: doorkeeper_access_token.token, description: nil,
                                  target_type: target_type, target_id: target_id

      expect(response.status).to eq 422
    end

    it 'does not allow reporting something other than user, content or comment' do
      post '/api/v1/pub/reports', access_token: doorkeeper_access_token.token, description: description,
                                  target_type: 'test', target_id: target_id

      expect(response.status).to eq 422
    end

    it 'contains report data' do
      post '/api/v1/pub/reports', access_token: doorkeeper_access_token.token, description: description,
                                  target_type: target_type, target_id: target_id

      expect(json.keys.sort).to eq %w(id description).sort
      expect(json['description']).to eq description
    end
  end
end
