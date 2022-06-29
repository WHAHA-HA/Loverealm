require 'rails_helper'

RSpec.describe Admin::MentorsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/mentors').to route_to('admin/mentors#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/mentors/new').to route_to('admin/mentors#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/mentors/1').to route_to('admin/mentors#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/mentors/1/edit').to route_to('admin/mentors#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/mentors').to route_to('admin/mentors#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/mentors/1').to route_to('admin/mentors#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/mentors/1').to route_to('admin/mentors#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/mentors/1').to route_to('admin/mentors#destroy', id: '1')
    end
  end
end
