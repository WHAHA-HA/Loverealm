require 'rails_helper'

describe 'api/v1/pub/suggested_users' do
  describe 'GET api/v1/pub/suggested_users' do
    before do
      allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
    end

    let!(:avatar) { File.new(Rails.root.join('spec', 'support', 'fixtures', 'rails.png')) }
    let!(:user1) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user_with_content) }
    let!(:hash_tag) { FactoryGirl.create(:hash_tag) }
    let!(:hash_tags_user1) { FactoryGirl.create(:hash_tags_user, user: user1, hash_tag: hash_tag) }
    let!(:hash_tags_user2) { FactoryGirl.create(:hash_tags_user, user: user2, hash_tag: hash_tag) }

    let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
    let!(:doorkeeper_access_token) do
      FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application,
                                                   resource_owner_id: user1.id)
    end

    it 'returns status 200' do
      get '/api/v1/pub/suggested_users', access_token: doorkeeper_access_token.token

      expect(response.status).to eq 200
    end

    it 'returns array of suggested users' do
      get '/api/v1/pub/suggested_users', access_token: doorkeeper_access_token.token

      expect(json).to be_kind_of Array
      expect(json.first.keys.sort).to eq %w(id full_name avatar_url).sort
    end
  end
end
