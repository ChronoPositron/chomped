require 'rails_helper'

RSpec.describe 'urls/index', type: :view do
  before(:each) do
    assign(:urls, create_list(:url, 2))
  end

  it 'renders a list of urls' do
    render
    assert_select 'tr>td', text: 'http://www.example.com/'.to_s, count: 2
    assert_select 'tr>td', text: 0.to_s, count: 2
    assert_select 'tr>td', text: 'delete'.to_s, count: 2
  end
end
