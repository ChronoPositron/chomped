require 'rails_helper'

RSpec.describe 'true' do
  it 'should be true' do
    expect(true).to be true
  end
end

RSpec.describe 'false' do
  it 'should be false' do
    expect(false).to be false
  end
end