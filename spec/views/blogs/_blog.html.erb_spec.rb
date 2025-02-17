require 'rails_helper'

RSpec.describe "blogs/_blog", type: :view do
  let(:user) { FactoryBot.create(:user) }
  let(:blog) { FactoryBot.create(:blog, user: user) }
  
  before do
    allow(view).to receive(:current_user).and_return(user)
  end

  it 'shows blog content' do
    render partial: 'blogs/blog', locals: { blog: blog }
    
    expect(rendered).to have_content(blog.title)
    expect(rendered).to have_content(blog.body)
  end

  it 'shows action links' do
    render partial: 'blogs/blog', locals: { blog: blog }
    
    expect(rendered).to have_link('Show', href: blog_path(blog))
    expect(rendered).to have_link('Edit', href: edit_blog_path(blog))
    expect(rendered).to have_css("a[href='#{blog_path(blog)}'][data-turbo-method='delete']")
    expect(rendered).to have_css("a[data-turbo-confirm='Are you sure?']")
  end
end 