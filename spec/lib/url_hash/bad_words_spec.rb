require 'rails_helper'
require 'url_hash/bad_words'

RSpec.describe UrlHash::BadWords do
  describe '.load' do
    it 'should attempt to load the config file' do
      expect(YAML).to receive(:load_file)
        .with(Rails.root.join('config/bad_words.yml'))
        .and_return('test' => %w(sdf 123))

      expect(UrlHash::BadWords.load).to match_array(%w(sdf 123))
    end
  end

  describe '#clean?' do
    before(:each) do
      expect(YAML).to receive(:load_file)
        .with(Rails.root.join('config/bad_words.yml'))
        .and_return('test' => %w(boo far))
    end

    %w(clean beepfoo).each do |word|
      it "clean string #{word} should pass" do
        expect(UrlHash::BadWords.new.clean?(word)).to be true
      end
    end

    %w(beepboop beeBoOp FArout).each do |word|
      it "dirty string #{word} should fail" do
        expect(UrlHash::BadWords.new.clean?(word)).to be false
      end
    end
  end
end
