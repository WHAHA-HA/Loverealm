require 'rails_helper'

describe 'api/v1/pub/dashboard' do
  let!(:user1) { FactoryGirl.create(:user, is_newbie: false) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:message) { FactoryGirl.create(:message, sender: user2, receiver: user1) }
  let!(:relationship1) { FactoryGirl.create(:relationship, follower: user1, followed: user2) }
  let!(:relationship2) { FactoryGirl.create(:relationship, follower: user2, followed: user1) }

  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application, resource_owner_id: user1.id)
  end

  describe 'GET api/v1/pub/dashboard' do
    it 'returns status 200' do
      get '/api/v1/pub/dashboard', access_token: doorkeeper_access_token.token

      expect(response.status).to eq 200
    end

    it 'contains dashboard fields' do
      status = FactoryGirl.create(:status, user: user1)
      # user3 = FactoryGirl.create(:user, is_newbie: false)

      # hash_tag = FactoryGirl.create(:hash_tag)
      # hash_tags_user1 = FactoryGirl.create(:hash_tags_user, user: user1, hash_tag: hash_tag)
      # hash_tags_user3 = FactoryGirl.create(:hash_tags_user, user: user3, hash_tag: hash_tag)

      get '/api/v1/pub/dashboard', access_token: doorkeeper_access_token.token


      expect(json.keys.sort).to eq %w(number_of_unread_messages number_of_unread_notifications number_of_followers
        number_of_followings number_of_posts contents).sort
      expect(json['number_of_unread_messages']).to eq user1.received_messages.unread_messages.count
      expect(json['number_of_unread_notifications']).to eq user1.unread_notification_count
      expect(json['number_of_followers']).to eq user1.num_of_followers
      expect(json['number_of_followings']).to eq user1.following.count
      # expect(json["number_of_suggested_users"]).to eq 1
      expect(json['number_of_posts']).to eq user1.contents.count
      expect(json['contents']).to be_kind_of Array
    end

    it 'contains user details for single content' do
      status = FactoryGirl.create(:status, user: user2)

      get '/api/v1/pub/dashboard', access_token: doorkeeper_access_token.token
      expect(json['contents'].first['user']['id']).to eq status.user.id
      expect(json['contents'].first['user']['full_name']).to eq status.user.full_name
      expect(json['contents'].first['user']['avatar_url']).to eq status.user.avatar.url
    end

    it 'contains status fields if there is one' do
      status = FactoryGirl.create(:status, user: user2)
      status.liked_by user2

      comment = FactoryGirl.create(:comment, user: user2, content: status)

      get '/api/v1/pub/dashboard', access_token: doorkeeper_access_token.token

      expect(json['contents'].first['id']).to eq status.id
      expect(json['contents'].first['description']).to eq status.description
      expect(json['contents'].first['created_at']).to eq status.created_at.to_i
      expect(json['contents'].first['updated_at']).to eq status.updated_at.to_i
      expect(json['contents'].first['number_of_likes']).to eq 1
      expect(json['contents'].first['number_of_comments']).to eq 1
      expect(json['contents'].first['liked']).to eq false
    end

    it 'contains picture fields if there is one' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)

      picture = FactoryGirl.create(:picture, user: user2)

      get '/api/v1/pub/dashboard', access_token: doorkeeper_access_token.token

      expect(json['contents'].first['id']).to eq picture.id
      expect(json['contents'].first['description']).to eq picture.description
      expect(json['contents'].first['image_url']). to eq picture.image.url
      expect(json['contents'].first['created_at']).to eq picture.created_at.to_i
      expect(json['contents'].first['updated_at']).to eq picture.updated_at.to_i
    end

    it 'contains story fields if there is one' do
      story = FactoryGirl.create(:story, user: user2)

      get '/api/v1/pub/dashboard', access_token: doorkeeper_access_token.token

      expect(json['contents'].first['id']).to eq story.id
      expect(json['contents'].first['description']).to eq story.description
      expect(json['contents'].first['image_url']). to eq story.image.url
      expect(json['contents'].first['title']). to eq story.title
      expect(json['contents'].first['created_at']).to eq story.created_at.to_i
      expect(json['contents'].first['updated_at']).to eq story.updated_at.to_i
    end

    it 'contains information about use that shared content' do
      status = FactoryGirl.create(:status, user: user2)
      Share.create(user: user1, content: status)

      get '/api/v1/pub/dashboard', access_token: doorkeeper_access_token.token
      expect(json['contents'].first['shared_by']['id']).to eq user1.id
      expect(json['contents'].first['shared_by']['full_name']).to eq user1.full_name
      expect(json['contents'].first['shared_by']['avatar_url']).to eq user1.avatar.url
    end
  end
end
