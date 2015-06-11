require 'rails_helper'

# Source: https://gist.github.com/adamico/2a781d6a4fc2ff577e7f
# Source: http://gist.github.com/bf4/5320847
# spec/validators/uri_validator_spec.rb
class Foo
  include ActiveModel::Validations
  attr_accessor :url
  validates :url, uri: true
end

RSpec.describe UriValidator do
  subject { Foo.new }

  it 'should be valid for a valid http url' do
    subject.url = 'http://www.google.com'
    expect(subject).to be_valid
    expect(subject.errors.full_messages).to be_empty
  end

  ['http:/www.google.com', '<>hi',
   'www.google.com', 'google.com', 'http:'].each do |invalid_url|
    it "#{invalid_url.inspect} is an invalid url" do
      subject.url = invalid_url
      expect(subject).not_to be_valid
      expect(subject.errors).to have_key(:url)
      expect(subject.errors[:url]).to(
        include(I18n.t(:bad_uri, scope: 'activemodel.errors.messages'))
      )
    end
  end

  ['ftp://ftp.google.com', 'ssh://google.com'].each do |invalid_url|
    it "#{invalid_url.inspect} does not respect the allowed protocols" do
      subject.url = invalid_url
      expect(subject).not_to be_valid
      expect(subject.errors).to have_key(:url)
      expect(subject.errors[:url]).to(
        include(I18n.t(:bad_protocol,
                       scope: 'activemodel.errors.messages',
                       protocols: 'http / https'))
      )
    end
  end
end
