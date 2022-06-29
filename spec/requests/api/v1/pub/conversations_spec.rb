require 'rails_helper'

describe 'api/v1/pub/conversations' do
  let!(:user1) { FactoryGirl.create(:user, is_newbie: false) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:conversation) { FactoryGirl.create(:conversation, participants: [user1.id, user2.id]) }
  let!(:first_message) { FactoryGirl.create(:message, conversation: conversation, sender: user2, receiver: user1) }
  let!(:last_message) { FactoryGirl.create(:message, conversation: conversation, sender: user2, receiver: user1) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application, resource_owner_id: user1.id)
  end

  describe 'GET api/v1/pub/conversations' do
    it 'returns status 200' do
      get '/api/v1/pub/conversations', access_token: doorkeeper_access_token.token

      expect(response.status).to eq 200
    end

    it 'contains array of conversations' do
      get '/api/v1/pub/conversations', access_token: doorkeeper_access_token.token

      expect(json.first.keys.sort).to eq %w(id user number_of_messages last_message).sort
      expect(json.first['id']).to eq conversation.id
      expect(json.first['number_of_messages']).to eq conversation.messages.count
      expect(json.first['user']['id']).to eq user2.id
      expect(json.first['user']['full_name']).to eq user2.full_name
      expect(json.first['user']['avatar_url']).to eq user2.avatar.url
      expect(json.first['last_message']['id']).to eq last_message.id
      expect(json.first['last_message']['body']).to eq last_message.body
      expect(json.first['last_message']['is_read']).to eq false
      expect(json.first['last_message']['created_at']).to eq last_message.created_at.to_i
      expect(json.first['last_message']['updated_at']).to eq last_message.updated_at.to_i
    end
  end

  describe 'GET api/v1/pub/conversations/:id' do
    it 'returns status 200' do
      get "/api/v1/pub/conversations/#{conversation.id}", access_token: doorkeeper_access_token.token

      expect(response.status).to eq 200
    end

    it 'returns status 404 if there is no conversation with given id' do
      conversation.destroy

      get "/api/v1/pub/conversations/#{conversation.id}", access_token: doorkeeper_access_token.token

      expect(response.status).to eq 404
    end

    it 'contains conversaion fields' do
      get "/api/v1/pub/conversations/#{conversation.id}", access_token: doorkeeper_access_token.token

      expect(json.keys.sort).to eq %w(id user number_of_messages messages).sort
      expect(json['id']).to eq conversation.id
      expect(json['number_of_messages']).to eq conversation.messages.count
      expect(json['user']['id']).to eq user2.id
      expect(json['user']['full_name']).to eq user2.full_name
      expect(json['user']['avatar_url']).to eq user2.avatar.url
      expect(json['messages'].first['id']).to eq last_message.id
      expect(json['messages'].first['body']).to eq last_message.body
      expect(json['messages'].first['receiver_id']).to eq last_message.receiver_id
      expect(json['messages'].first['sender_id']).to eq last_message.sender_id
      expect(json['messages'].first['is_read']).to eq last_message.is_read
      expect(json['messages'].first['removed_at']).to eq nil
      expect(json['messages'].first['created_at']).to eq last_message.created_at.to_i
      expect(json['messages'].first['updated_at']).to eq last_message.updated_at.to_i
    end
  end
end
