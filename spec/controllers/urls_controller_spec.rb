require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET #index' do
    it 'assigns all urls as @urls' do
      url = create(:url)
      get :index, {}
      expect(assigns(:urls)).to eq([url])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested url as @url' do
      url = create(:url)
      get :show, hash_url: url.to_param
      expect(assigns(:url)).to eq(url)
    end

    it 'responds with 404 Not found for invalid url' do
      expect do
        get :show, hash_url: 'CLEANK'
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #new' do
    it 'assigns a new url as @url' do
      get :new, {}
      expect(assigns(:url)).to be_a_new(Url)
    end
  end

  describe 'GET #delete' do
    it 'assigns the requested url as @url' do
      url = create(:url)
      get :delete, hash_url: url.to_param
      expect(assigns(:url)).to eq(url)
    end
  end

  describe 'GET #redirect' do
    it 'redirects to the original url' do
      url = create(:url)
      get :redirect, hash_url: url.to_param
      expect(response).to redirect_to(url.original)
    end

    it 'increases the views by one' do
      url = create(:url)
      get :redirect, hash_url: url.to_param
      url.reload
      expect(url.views).to eq(1)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Url' do
        expect do
          post :create, url: attributes_for(:url)
        end.to change(Url, :count).by(1)
      end

      it 'assigns a newly created url as @url' do
        post :create, url: attributes_for(:url)
        expect(assigns(:url)).to be_a(Url)
        expect(assigns(:url)).to be_persisted
      end

      it 'redirects to the created url' do
        post :create, url: attributes_for(:url)
        expect(response).to redirect_to(Url.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved url as @url' do
        post :create, url: attributes_for(:url, original: '')
        expect(assigns(:url)).to be_a_new(Url)
      end

      it 're-renders the \'new\' template' do
        post :create, url: attributes_for(:url, original: '')
        expect(response).to render_template('new')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid params' do
      it 'destroys the requested url' do
        url = create(:url)
        expect do
          delete :destroy, hash_url: url.to_param, url: attributes_for(:url_with_confirmed_delete)
        end.to change(Url, :count).by(-1)
      end

      it 'redirects to the urls list' do
        url = create(:url)
        delete :destroy, hash_url: url.to_param, url: attributes_for(:url_with_confirmed_delete)
        expect(response).to redirect_to(urls_url)
      end
    end

    context 'with invalid params' do
      it 're-renders the \'delete\' template' do
        url = create(:url)
        delete :destroy, hash_url: url.to_param,
                         url: attributes_for(:url, delete_token_confirmation: 'INVALID')
        expect(response).to render_template('delete')
      end

      it 'does not destroy the requested url' do
        url = create(:url)
        expect do
          delete :destroy, hash_url: url.to_param,
                           url: attributes_for(:url, delete_token_confirmation: 'INVALID')
        end.not_to change(Url, :count)
      end
    end
  end
end
