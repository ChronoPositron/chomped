require 'rails_helper'

RSpec.describe Url, type: :model do
  describe '#original=' do
    it 'should validate that original is a url' do
      expect(Url.new)
        .to allow_value('http://www.example.com', 'https://example.org/test').for(:original)
    end

    it 'should validate "foo" is not a url' do
      expect(Url.new).not_to allow_value('foo').for(:original)
    end

    it 'should validate "bar.what" is not a url' do
      expect(Url.new).not_to allow_value('bar.what').for(:original)
    end

    it 'should validate a script is not a url' do
      expect(Url.new)
        .not_to allow_value('<script type="javascript">alert("test");</script>').for(:original)
    end
  end

  describe '#to_param' do
    it 'should return a hash_url string' do
      expect(Rails.application.secrets).to receive(:hashids_salt).and_return('this is my salt')
      expect(Url.new(id: 1).to_param).to eq('bVy2QH')
    end
  end

  describe '#destroy_is_confirmed?' do
    it 'triggers destroy_is_confirmed? on destroy' do
      url = create(:url)
      expect(url).to receive(:destroy_is_confirmed?)
      url.destroy
    end

    it 'adds an error on non-matching token' do
      url = create(:url)
      url.destroy
      expect(url.errors).to have_key(:delete_token_confirmation)
      expect(url.errors[:delete_token_confirmation]).to(
        include('is an invalid delete token')
      )
    end

    it 'has no error on matching token' do
      url = create(:url)
      url.delete_token_confirmation = 'delete'
      url.destroy
      expect(url.errors).not_to have_key(:delete_token_confirmation)
    end
  end

  describe '.decode' do
    it 'should return an id' do
      expect(Rails.application.secrets).to receive(:hashids_salt).and_return('this is my salt')
      expect(Url.decode('bVy2QH')).to eq(1)
    end
  end

  describe '.encode' do
    it 'should return a hash_url string' do
      expect(Rails.application.secrets).to receive(:hashids_salt).and_return('this is my salt')
      expect(Url.encode(1)).to eq('bVy2QH')
    end
  end
end
