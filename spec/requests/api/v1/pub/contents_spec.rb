require 'rails_helper'

describe 'api/v1/pub/contents' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application,
                                                 resource_owner_id: user.id)
  end

  describe 'GET api/v1/pub/contnets' do
    let!(:status1) { FactoryGirl.create(:status, user: user) }
    let!(:status2) { FactoryGirl.create(:status, user: user) }

    it 'returns status 200 and correct response' do
      get "/api/v1/pub/contents", access_token: doorkeeper_access_token.token

      expect(response.status).to eq 200
      expect(json.length).to eq 2
    end

    it 'returns list of content filtered by hash tag' do
      hash_tag = FactoryGirl.create(:hash_tag)
      status2.hash_tags << hash_tag
      get "/api/v1/pub/contents", access_token: doorkeeper_access_token.token, tag_id: hash_tag.id

      expect(response.status).to eq 200
      expect(json.length).to eq 1
      expect(json.first['hash_tags'].first['name']).to eq hash_tag.name
    end

  end

  describe 'delete status' do
    let!(:status) { FactoryGirl.create(:status, user: user) }

    it 'returns status 204 for successful delete' do
      delete "/api/v1/pub/contents/#{status.id}", access_token: doorkeeper_access_token.token

      expect(response.status).to eq 204
    end
  end

  describe 'delete story' do
    let!(:story) { FactoryGirl.create(:story, user: user) }

    it 'returns status 204 for successful delete' do
      delete "/api/v1/pub/contents/#{story.id}", access_token: doorkeeper_access_token.token

      expect(response.status).to eq 204
    end
  end

  describe 'delete picture' do
    let!(:picture) { FactoryGirl.create(:picture, user: user) }

    it 'returns status 204 for successful delete' do
      delete "/api/v1/pub/contents/#{picture.id}", access_token: doorkeeper_access_token.token

      expect(response.status).to eq 204
    end
  end

  describe 'POST api/v1/pub/contents/{id}/like' do
    let!(:picture) { FactoryGirl.create(:picture, user: user) }

    it 'create score and returns 201 for successful operation' do
      post "/api/v1/pub/contents/#{picture.id}/like", access_token: doorkeeper_access_token.token

      expect(user.up_votes(picture)).to eq true
      expect(response.status).to eq 201
    end
  end

  describe 'POST api/v1/pub/contents/{id}/dislike' do
    let!(:picture) { FactoryGirl.create(:picture, user: user) }

    it 'remove score and returns 201 for successful operation' do
      user.likes picture

      post "/api/v1/pub/contents/#{picture.id}/dislike", access_token: doorkeeper_access_token.token

      expect(user.votes.up).to be_empty
      expect(response.status).to eq 201
    end
  end
end
