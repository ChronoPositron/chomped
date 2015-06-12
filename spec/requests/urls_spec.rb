require 'rails_helper'

RSpec.describe 'Urls', type: :request do
  context 'with HTTP format' do
    describe 'GET /urls' do
      it 'loads' do
        get urls_path
        expect(response).to have_http_status(200)
        expect(response).to render_template(:index)
      end
    end

    describe 'GET /urls/new' do
      it 'creates a url and redirects to the url\'s page' do
        get '/urls/new'
        expect(response).to render_template(:new)

        post '/urls', url: { original: 'not-a-url' }
        expect(response).to render_template(:new)
        expect(response.body).to include('is an invalid url')

        post '/urls', url: { original: 'http://www.example.com' }
        expect(response).to redirect_to(assigns(:url))
        follow_redirect!

        expect(response).to render_template(:show)
        expect(response.body).to include('Url was successfully created.')
        expect(response.body).to include('http://www.example.com')
      end
    end

    describe 'DELETE /urls/EXAMPLE/delete' do
      it 'deletes a url and redirects to the url index page' do
        url = create(:url)

        get delete_url_path(url)
        expect(response).to render_template(:delete)

        delete delete_url_path(url), url: { delete_token_confirmation: 'oops' }
        expect(response).to render_template(:delete)
        expect(response.body).to include('is an invalid delete token')

        delete delete_url_path(url), url: { delete_token_confirmation: 'delete' }
        expect(response).to redirect_to('/urls')
        follow_redirect!

        expect(response).to render_template(:index)
        expect(response.body).to include('Url was successfully destroyed.')
      end
    end

    describe 'GET /EXAMPLE' do
      it 'redirects to the original url' do
        url = create(:url)

        get shortened_path(url)
        expect(response).to redirect_to('http://www.example.com/')
      end
    end
  end

  context 'with JSON format' do
    let(:response_body) { JSON.parse(response.body) }

    describe 'GET /EXAMPLE.json' do
      it 'returns the original url' do
        url = create(:url)

        get shortened_path(url), format: :json
        expect(response_body['url']).to eq('http://www.example.com/')
      end
    end

    describe 'GET /urls/EXAMPLE.json' do
      it 'returns the details of the url' do
        url = create(:url)

        get url_path(url), format: :json
        expect(response_body['url']).to eq('http://www.example.com/')
        expect(response_body['views']).to eq(0)
        expect(response_body).not_to have_key('delete_token')
      end
    end

    describe 'GET /urls.json' do
      it 'returns a blank array when there\'s no urls' do
        get urls_path, format: :json
        expect(response_body.size).to eq(0)
      end

      it 'returns a list with a single url' do
        expect(Rails.application.secrets).to receive(:hashids_salt)
          .at_least(:once).and_return('this is my salt')
        create(:url)

        get urls_path, format: :json

        expect(response_body.size).to eq(1)
        expect(response_body[0]['url']).to eq('http://www.example.com/bVy2QH.json')
        expect(response_body[0]['details']).to eq('http://www.example.com/urls/bVy2QH.json')
        expect(response_body[0]).not_to have_key('views')
        expect(response_body[0]).not_to have_key('delete_token')
      end

      it 'returns both urls' do
        create_list(:url, 2)

        get urls_path, format: :json

        expect(response_body.size).to eq(2)
        response_body.each do |x|
          expect(x).to have_key('url')
          expect(x).to have_key('details')
          expect(x).not_to have_key('views')
          expect(x).not_to have_key('delete_token')
        end
      end
    end
  end
end
