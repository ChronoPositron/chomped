require 'rails_helper'

RSpec.describe 'urls/new', type: :view do
  before(:each) do
    assign(:url, build(:url))
  end

  it 'renders new url form' do
    render

    assert_select 'form[action=?][method=?]', urls_path, 'post' do
      assert_select 'input#url_original[name=?]', 'url[original]'
    end
  end
end
