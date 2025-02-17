require 'rails_helper'

RSpec.describe "blogs/index", type: :view do
  let(:user) { FactoryBot.create(:user) }
  let(:blogs) { FactoryBot.create_list(:blog, 2, user: user) }
  
  before do
    assign(:blogs, blogs)
    assign(:pagy, Pagy.new(count: 2, page: 1))
    allow(view).to receive(:current_user).and_return(user)
    
    # Mock the request for sortable helper
    allow(view).to receive(:request).and_return(
      double('Request', 
        path: '/blogs',
        GET: {},
        query_parameters: {}
      )
    )

    # Mock pagy helper
    allow(view).to receive(:pagy_bootstrap_nav) { '' }
  end

  it 'renders a list of blogs' do
    render
    expect(rendered).to have_css('table.table')
    expect(rendered).to have_css('tr', count: 3) # header + 2 blogs
  end

  it 'shows blog content' do
    render
    blogs.each do |blog|
      expect(rendered).to have_content(blog.title)
      expect(rendered).to have_content(blog.body)
    end
  end

  it 'shows action links' do
    render
    blogs.each do |blog|
      expect(rendered).to have_link('Show', href: blog_path(blog))
      expect(rendered).to have_link('Edit', href: edit_blog_path(blog))
      expect(rendered).to have_css("a[href='#{blog_path(blog)}'][data-turbo-method='delete']")
    end
  end

  it 'shows delete confirmation dialog' do
    render
    blogs.each do |blog|
      expect(rendered).to have_css("a[data-turbo-confirm='Are you sure?']")
    end
  end
end 