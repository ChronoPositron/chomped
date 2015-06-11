require 'rails_helper'

RSpec.describe 'urls/show', type: :view do
  before(:each) do
    @url = assign(:url, create(:url))
  end

  it 'renders link to itself' do
    render
    expect(rendered).to match(shortened_url(@url))
  end

  it 'renders some attributes in <p>' do
    render
    expect(rendered).to match(%r{http:\/\/www.example.com})
    expect(rendered).to match(/0/)
    expect(rendered).not_to match(/delete/)
  end
end
