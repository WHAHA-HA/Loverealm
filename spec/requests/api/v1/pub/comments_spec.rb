require 'rails_helper'

describe 'api/v1/pub/comments' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application,
                                                 resource_owner_id: user.id)
  end
  let!(:status) { FactoryGirl.create(:status, user: user) }
  let!(:body) { Faker::Lorem.sentence }

  describe 'POST api/v1/pub/comments' do
    it 'returns status 201 for successful create' do
      post '/api/v1/pub/comments', access_token: doorkeeper_access_token.token, body: body, content_id: status.id

      expect(response.status).to eq 201
    end

    it 'returns status 422 for unsuccessfull create' do
      post '/api/v1/pub/comments', access_token: doorkeeper_access_token.token, body: nil, content_id: status.id

      expect(response.status).to eq 422
    end

    it 'contains comment fields' do
      post '/api/v1/pub/comments', access_token: doorkeeper_access_token.token, body: body, content_id: status.id

      expect(json.keys.sort).to eq %w(id body user created_at updated_at).sort
      expect(json['body']).to eq body
      expect(json['user']['id']).to eq user.id
      expect(json['user']['full_name']).to eq user.full_name
      expect(json['user']['avatar_url']).to eq user.avatar.url
    end
  end

  describe 'PUT api/v1/pub/comments/:id' do
    let!(:comment) { FactoryGirl.create(:comment, user: user, content: status) }
    let!(:new_body) { Faker::Lorem.sentence }

    it 'returns status 201 for successful update' do
      put "/api/v1/pub/comments/#{comment.id}", access_token: doorkeeper_access_token.token, body: new_body

      expect(response.status).to eq 200
    end

    it 'returns status 422 for unsuccessfull update' do
      put "/api/v1/pub/comments/#{comment.id}", access_token: doorkeeper_access_token.token, body: nil, content_id: status.id

      expect(response.status).to eq 422
    end

    it 'contains comment fields' do
      put "/api/v1/pub/comments/#{comment.id}", access_token: doorkeeper_access_token.token, body: new_body, content_id: status.id

      expect(json.keys.sort).to eq %w(id body user created_at updated_at).sort
      expect(json['body']).to eq new_body
      expect(json['user']['id']).to eq user.id
      expect(json['user']['full_name']).to eq user.full_name
      expect(json['user']['avatar_url']).to eq user.avatar.url
    end
  end
end
