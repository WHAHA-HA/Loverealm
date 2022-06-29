require 'rails_helper'

describe 'api/v1/pub/relationships' do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application,
                                                 resource_owner_id: user1.id)
  end

  describe 'POST api/v1/pub/relationships' do
    it 'returns status 201 for follow of another user' do
      post '/api/v1/pub/relationships/follow', access_token: doorkeeper_access_token.token, followed_id: user2.id

      expect(response.status).to eq 201
    end

    it 'adds relationship between 2 users' do
      post '/api/v1/pub/relationships/follow', access_token: doorkeeper_access_token.token, followed_id: user2.id

      expect(user1.following?(user2)).to eq true
    end

    it 'returns status 404 if there is no user with such id' do
      user2.destroy

      post '/api/v1/pub/relationships/follow', access_token: doorkeeper_access_token.token, followed_id: user2.id

      expect(response.status).to eq 404
    end
  end

  describe 'DELETE api/v1/pub/relationships/:id' do
    let!(:relationship) { FactoryGirl.create(:relationship, follower: user1, followed: user2) }

    it 'returns status 200 for successful unfollow' do
      post '/api/v1/pub/relationships/unfollow', access_token: doorkeeper_access_token.token, followed_id: user2.id

      expect(response.status).to eq 204
    end

    it 'adds relationship between 2 users' do
      post '/api/v1/pub/relationships/unfollow', access_token: doorkeeper_access_token.token, followed_id: user2.id

      expect(user1.following?(user2)).to eq false
    end

    it 'returns status 404 if there is no user with such id' do
      user2.destroy

      post '/api/v1/pub/relationships/unfollow', access_token: doorkeeper_access_token.token, followed_id: user2.id

      expect(response.status).to eq 404
    end
  end
end
