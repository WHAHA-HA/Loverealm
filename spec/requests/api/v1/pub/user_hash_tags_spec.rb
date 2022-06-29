require 'rails_helper'

describe 'api/v1/pub/users_hash_tags' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application,
                                                 resource_owner_id: user.id)
  end
  let!(:hash_tag1) { FactoryGirl.create(:hash_tag) }

  describe 'POST api/v1/pub/users/{user_id}/hash_tags' do
    it 'returns status 201 when hashtag ids supplied' do
      post "/api/v1/pub/users/#{user.id}/hash_tags", access_token: doorkeeper_access_token.token, hash_tag_ids: [hash_tag1.id]

      expect(response.status).to eq 201
    end

    it 'returns status 201 when existing hashtag names supplied' do
      post "/api/v1/pub/users/#{user.id}/hash_tags", access_token: doorkeeper_access_token.token, hash_tag_names: [hash_tag1.name]

      expect(response.status).to eq 201
    end

    it 'returns status 201 when new hashtag name supplied (hashtag that does not exist)' do
      hash_tag1.destroy

      post "/api/v1/pub/users/#{user.id}/hash_tags", access_token: doorkeeper_access_token.token, hash_tag_names: [hash_tag1.name]

      expect(response.status).to eq 201
    end
  end
end
