require 'rails_helper'

describe 'api/v1/pub/invitations' do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:doorkeeper_application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:doorkeeper_access_token) do
    FactoryGirl.create(:doorkeeper_access_token, application: doorkeeper_application, resource_owner_id: user1.id)
  end

  describe 'POST api/v1/pub/invitations' do
    it 'returns status 201 for successful create' do
      allow(InfobipService).to receive(:send_invitation_sms).and_return({ destinationAddress: '12345678900'})

      post '/api/v1/pub/invitations', access_token: doorkeeper_access_token.token, "emails[]": 'test@loverealm.com'

      expect(response.status).to eq 201
    end
  end
end
