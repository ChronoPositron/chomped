require 'rails_helper'

RSpec.describe 'urls/delete', type: :view do
  before(:each) do
    @url = assign(:url, create(:url))
  end

  it 'renders the delete url form' do
    render

    assert_select 'form[action=?][method=?]', delete_url_path(@url), 'post' do
      assert_select 'input#url_delete_token_confirmation[name=?]', 'url[delete_token_confirmation]'
    end
  end
end
