require 'rails_helper'

describe 'api/v1/pub/shares' do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:content) { FactoryGirl.create(:status) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application,
                                                 resource_owner_id: user1.id)
  end

  describe 'POST api/v1/pub/shares' do
    it 'returns status 201 when user share content' do
      post '/api/v1/pub/shares', access_token: doorkeeper_access_token.token, content_id: content.id

      expect(response.status).to eq 201
    end

    it 'returns status 404 if there is no content with such id' do
      post '/api/v1/pub/shares', access_token: doorkeeper_access_token.token, content_id: 0

      expect(response.status).to eq 404
    end
  end

  describe 'DELETE api/v1/pub/shares' do
    it 'returns status 204 when user stop sharing' do
      delete '/api/v1/pub/shares', access_token: doorkeeper_access_token.token, content_id: content.id

      expect(response.status).to eq 204
    end

    it 'returns status 404 if there is no content with such id' do
      delete '/api/v1/pub/shares', access_token: doorkeeper_access_token.token, content_id: 0

      expect(response.status).to eq 404
    end
  end
end
