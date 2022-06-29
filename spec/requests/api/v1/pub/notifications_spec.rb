require 'rails_helper'

describe 'api/v1/pub/notifications' do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }

  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application, resource_owner_id: user1.id)
  end

  describe 'GET api/v1/pub/notifications' do
    let!(:relationship) { FactoryGirl.create(:relationship, follower: user2, followed: user1) }
    let!(:activity) { Notification.for_user(user1).first }

    it 'returns status 200' do
      get '/api/v1/pub/notifications', access_token: doorkeeper_access_token.token

      expect(response.status).to eq 200
    end

    it 'returns proper activity fields' do
      get '/api/v1/pub/notifications', access_token: doorkeeper_access_token.token

      expect(json.first['id']).to eq activity.id
      expect(json.first['trackable_type']).to eq activity.trackable_type
      expect(json.first['trackable_id']).to eq activity.trackable_id
      expect(json.first['key']).to eq activity.key
      expect(json.first['owner']['id']).to eq activity.owner.id
      expect(json.first['owner']['full_name']).to eq activity.owner.full_name
      expect(json.first['owner']['avatar_url']).to eq activity.owner.avatar_url
      expect(json.first['recipient']['id']).to eq activity.recipient.id
      expect(json.first['recipient']['full_name']).to eq activity.recipient.full_name
      expect(json.first['recipient']['avatar_url']).to eq activity.recipient.avatar_url
      expect(json.first['created_at']).to eq activity.created_at.to_i
      expect(json.first['updated_at']).to eq activity.updated_at.to_i
      expect(json.first['checked']).to eq false
    end

    it 'update \'notifications_checked_at\' column' do
      user1.update_column(:notifications_checked_at, nil)

      get '/api/v1/pub/notifications', access_token: doorkeeper_access_token.token
      expect(user1.reload.notifications_checked_at.to_date).to eq Date.today
    end
  end
end
