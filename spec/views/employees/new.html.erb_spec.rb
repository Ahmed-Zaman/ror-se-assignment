require 'rails_helper'

RSpec.describe "employees/new", type: :view do
  let(:employee) do
    {
      "name" => nil,
      "position" => nil,
      "salary" => nil,
      "date_of_birth" => nil
    }
  end

  before do
    assign(:employee, employee)
  end

  it 'renders new employee form' do
    render template: 'employees/new', locals: { 
      url: employees_path,
      method: :post
    }

    assert_select "form[action=?][method=?]", employees_path, "post" do
      assert_select "input[name=?]", "employee[name]"
      assert_select "input[name=?]", "employee[position]"
      assert_select "input[name=?]", "employee[salary]"
      assert_select "input[name=?]", "employee[date_of_birth]"
    end
  end

  it 'has navigation links' do
    render template: 'employees/new'
    expect(rendered).to have_link('Back to Employees', href: employees_path)
  end
end 