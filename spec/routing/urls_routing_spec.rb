require 'rails_helper'

RSpec.describe UrlsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/urls').to route_to('urls#index')
    end

    it 'routes to #new' do
      expect(get: '/urls/new').to route_to('urls#new')
    end

    it 'routes to #show' do
      expect(get: '/urls/1RjJRC').to route_to('urls#show', hash_url: '1RjJRC')
    end

    it 'routes to #show with shortcut' do
      expect(get: '/1RjJRC+').to route_to('urls#show', hash_url: '1RjJRC')
    end

    it 'routes to #redirect' do
      expect(get: '/1RjJRC').to route_to('urls#redirect', hash_url: '1RjJRC')
    end

    it 'doesn''t route to #redirect with shortened url less than our minimum' do
      expect(get: '/1RjJR').not_to route_to('urls#redirect', hash_url: '1RjJR')
    end

    it 'routes to #create' do
      expect(post: '/urls').to route_to('urls#create')
    end

    it 'routes to #delete' do
      expect(get: '/urls/1RjJRC/delete').to route_to('urls#delete', hash_url: '1RjJRC')
    end

    it 'routes to #destroy' do
      expect(delete: '/urls/1RjJRC/delete').to route_to('urls#destroy', hash_url: '1RjJRC')
    end
  end
end
