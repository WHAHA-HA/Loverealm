require 'rails_helper'

describe 'api/v1/pub/statuses' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application,
                                                 resource_owner_id: user.id)
  end
  let!(:description) { 'description' }

  describe 'POST api/v1/pub/statuses' do
    it 'returns status 201 for successful create' do
      post '/api/v1/pub/statuses', access_token: doorkeeper_access_token.token, description: description

      expect(response.status).to eq 201
    end

    it 'returns 422 for errors in saving' do
      post '/api/v1/pub/statuses', access_token: doorkeeper_access_token.token, description: nil

      expect(response.status).to eq 422
    end
  end

  describe 'PUT api/v1/pub/statuses/:id' do
    let!(:status) { FactoryGirl.create(:status, user: user) }

    it 'returns status 201 for successful update' do
      put "/api/v1/pub/statuses/#{status.id}", access_token: doorkeeper_access_token.token, description: "Updated status."
      expect(response.status).to eq 200
    end

    it 'returns 422 for errors in updating' do
      put "/api/v1/pub/statuses/#{status.id}", access_token: doorkeeper_access_token.token, description: nil

      expect(response.status).to eq 422
    end
  end

  describe 'GET api/v1/pub/statuses/:id' do
    let!(:status) { FactoryGirl.create(:status, user: user) }

    it 'returns status 200 for successful response' do
      get "/api/v1/pub/statuses/#{status.id}", access_token: doorkeeper_access_token.token

      expect(response.status).to eq 200
    end

    it 'returns status 404 when there is no status with given id' do
      status.destroy

      get "/api/v1/pub/statuses/#{status.id}", access_token: doorkeeper_access_token.token

      expect(response.status).to eq 404
    end

    it 'returns status fields in response' do
      status = FactoryGirl.create(:status, user: user)
      status.liked_by user

      comment = FactoryGirl.create(:comment, user: user, content: status)

      get "/api/v1/pub/statuses/#{status.id}", access_token: doorkeeper_access_token.token

      expect(json['id']).to eq status.id
      expect(json['description']).to eq status.description
      expect(json['number_of_likes']).to eq 1
      expect(json['number_of_comments']).to eq 1
      expect(json['created_at']).to eq status.created_at.to_i
      expect(json['updated_at']).to eq status.updated_at.to_i
      expect(json['liked']).to eq true

      expect(json['user']['id']).to eq status.user.id
      expect(json['user']['full_name']).to eq status.user.full_name
      expect(json['user']['avatar_url']).to eq status.user.avatar.url

      expect(json['comments'].first['id']).to eq comment.id
      expect(json['comments'].first['body']).to eq comment.body
      expect(json['comments'].first['created_at']).to eq comment.created_at.to_i
      expect(json['comments'].first['updated_at']).to eq comment.updated_at.to_i

      expect(json['comments'].first['user']['id']).to eq comment.user.id
      expect(json['comments'].first['user']['full_name']).to eq comment.user.full_name
      expect(json['comments'].first['user']['avatar_url']).to eq comment.user.avatar.url
    end
  end
end
