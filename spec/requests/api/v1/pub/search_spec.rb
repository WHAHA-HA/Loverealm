require 'rails_helper'

describe 'api/v1/pub/search' do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application, resource_owner_id: user1.id)
  end
  let!(:test_user) { FactoryGirl.create(:user, first_name: 'test') }
  let!(:test_story) { FactoryGirl.create(:story, title: 'test story title', user: test_user) }

  describe 'POST api/v1/pub/search' do
    it 'returns list of matches' do
      get '/api/v1/pub/search', access_token: doorkeeper_access_token.token, query: 'test'

      expect(response.status).to eq 200

      expect(json['users'].first['id']).to eq test_user.id
      expect(json['contents'].first['id']).to eq test_story.id
    end
  end

  describe 'POST api/v1/pub/search/:type' do
    context 'when type equals user' do
      it 'returns list of matches' do
        get '/api/v1/pub/search/users', access_token: doorkeeper_access_token.token, query: 'test'

        expect(response.status).to eq 200
        expect(json.first['id']).to eq test_user.id
      end
    end

     context 'when type equals contents' do
      it 'returns list of matches' do
        get '/api/v1/pub/search/contents', access_token: doorkeeper_access_token.token, query: 'test'

        expect(response.status).to eq 200
        expect(json.first['id']).to eq test_story.id
      end
    end
  end
end
