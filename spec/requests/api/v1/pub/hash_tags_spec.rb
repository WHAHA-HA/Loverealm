require 'rails_helper'

describe 'api/v1/pub/hash_tags' do
  describe 'GET api/v1/pub/hash_tags' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
    let!(:doorkeeper_access_token) do
      FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application,
                                                   resource_owner_id: user.id)
    end
    let!(:hash_tag) { FactoryGirl.create(:hash_tag) }

    it 'returns 200 status' do
      get '/api/v1/pub/hash_tags', access_token: doorkeeper_access_token.token

      expect(response.status).to eq 200
    end

    it 'contains hash tag fields' do
      get '/api/v1/pub/hash_tags', access_token: doorkeeper_access_token.token

      expect(json).to be_kind_of Array
      expect(json.first.keys.sort).to eq %w(id name).sort
    end
  end
end
