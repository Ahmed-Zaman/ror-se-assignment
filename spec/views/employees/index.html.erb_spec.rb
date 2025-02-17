require 'rails_helper'

RSpec.describe "employees/index", type: :view do
  let(:employees) do
    {
      "data" => [
        { "id" => 1, "name" => "John Doe", "salary" => 50000, "position" => "Developer", "date_of_birth" => "1990-01-01" }
      ],
      "meta" => {
        "current_page" => 1,
        "total_pages" => 1
      }
    }
  end

  before do
    assign(:employees, employees)
  end

  it 'renders a list of employees' do
    render
    expect(rendered).to have_css('table.table')
    expect(rendered).to have_text('John Doe')
    expect(rendered).to have_text('Developer')
  end

  it 'shows pagination links' do
    render
    expect(rendered).to have_css('.pagination')
    expect(rendered).to have_link('Next')
    expect(rendered).to have_link('Previous')
  end
end 