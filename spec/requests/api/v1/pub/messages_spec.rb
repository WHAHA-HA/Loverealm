require 'rails_helper'

describe 'api/v1/pub/messages' do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application, resource_owner_id: user1.id)
  end
  let!(:body) { Faker::Lorem.sentence }

  describe 'POST api/v1/pub/messages' do
    it 'returns status 201 for successful create' do
      post '/api/v1/pub/messages', access_token: doorkeeper_access_token.token, receiver_id: user2.id, body: body

      expect(response.status).to eq 201
    end

    it 'returns 404 if there is no receiver with given id' do
      user2.destroy

      post '/api/v1/pub/messages', access_token: doorkeeper_access_token.token, receiver_id: user2.id, body: body

      expect(response.status).to eq 404
    end

    it 'returns status 422 for unsuccessfull create' do
      post '/api/v1/pub/messages', access_token: doorkeeper_access_token.token,receiver_id: user2.id,  body: nil

      expect(response.status).to eq 422
    end

    it 'contains comment fields' do
      post '/api/v1/pub/messages', access_token: doorkeeper_access_token.token, receiver_id: user2.id, body: body

      expect(json.keys.sort).to eq %w(id body receiver_id sender_id is_read removed_at created_at updated_at).sort
      expect(json['body']).to eq body
      expect(json['receiver_id']).to eq user2.id
      expect(json['sender_id']).to eq user1.id
      expect(json['is_read']).to eq false
      expect(json['removed_at']).to eq nil
    end
  end

  describe 'DELETE api/v1/pub/messages' do
    let!(:conversation) { FactoryGirl.create(:conversation, participants: [user1.id, user2.id]) }
    let!(:message) { FactoryGirl.create(:message, conversation: conversation, sender: user1, receiver: user2) }

    it 'returns status 204' do
      delete "/api/v1/pub/messages/#{message.id}", access_token: doorkeeper_access_token.token

      expect(response.status).to eq 204
      expect(message.reload.removed?).to eq true
    end

    it 'returns status 404 if there is no message with given id' do
      message.destroy

      delete "/api/v1/pub/messages/#{message.id}", access_token: doorkeeper_access_token.token

      expect(response.status).to eq 404
    end
  end

  describe 'GET api/v1/pub/messages/deleted' do
    let!(:conversation) { FactoryGirl.create(:conversation, participants: [user1.id, user2.id]) }
    let!(:message) { FactoryGirl.create(:message, conversation: conversation, sender: user1, receiver: user2,
      removed: true, removed_at: Time.current) }

    it 'returns status 200' do
      get '/api/v1/pub/messages/deleted', access_token: doorkeeper_access_token.token

      expect(response.status).to eq 200
    end

    it 'returns messsage fields' do
      get '/api/v1/pub/messages/deleted', access_token: doorkeeper_access_token.token

      expect(json.keys.sort).to eq %w(number_of_messages messages).sort
      expect(json['number_of_messages']).to eq Message.trashed.count
      expect(json['messages'].first['id']).to eq message.id
      expect(json['messages'].first['body']).to eq message.body
      expect(json['messages'].first['receiver_id']).to eq message.receiver_id
      expect(json['messages'].first['sender_id']).to eq message.sender_id
      expect(json['messages'].first['is_read']).to eq message.is_read
      expect(json['messages'].first['removed_at']).to eq message.removed_at.to_i
      expect(json['messages'].first['created_at']).to eq message.created_at.to_i
      expect(json['messages'].first['updated_at']).to eq message.updated_at.to_i   
    end
  end
end
