require 'rails_helper'

RSpec.describe Admin::ReportsController, type: :controller do
  login_admin

  describe 'GET #index' do
    it 'assigns @reports' do
      report = FactoryGirl.create(:status_report)
      get :index
      expect(assigns(:reports)).to eq([report])
    end

    it 'render index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns @report' do
      report = FactoryGirl.create(:status_report)
      get :show, id: report.id
      expect(assigns(:report)).to eq(report)
    end

    it 'render show template' do
      get :show, id: FactoryGirl.create(:status_report).id
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #reviewed' do
    it 'mark report as reviewed' do
      report = FactoryGirl.create(:status_report)
      post :reviewed, id: report.id
      expect(report.reload.reviewed).to be true
    end

    it 'redirect to report list page' do
      report = FactoryGirl.create(:status_report)
      post :reviewed, id: report.id
      expect(response).to redirect_to admin_reports_path
    end
  end

  describe 'POST #process_report' do
    it 'with valid report' do
      report = FactoryGirl.create(:comment_report)
      post :process_report, id: report.id
      expect(report.reload.target).to be nil
    end
  end
end
