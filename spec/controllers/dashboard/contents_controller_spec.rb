require 'rails_helper'

RSpec.describe Dashboard::ContentsController, type: :controller do
  describe 'GET #show' do
    it 'returns http success' do
      status = FactoryGirl.create(:status)
      get :show, id: status.id
      expect(response).to have_http_status(:success)
    end
  end
end
