require 'rails_helper'

RSpec.describe "employees/edit", type: :view do
  let(:employee) do
    {
      "id" => 1,
      "name" => "John Doe",
      "position" => "Developer",
      "salary" => "75000",
      "date_of_birth" => "1990-01-01"
    }
  end

  before do
    assign(:employee, employee)
  end

  it 'renders edit employee form' do
    render template: 'employees/edit', locals: { 
      url: employee_path(employee["id"]),
      method: :put
    }

    assert_select "form[action=?][method=?]", employee_path(employee["id"]), "post" do
      assert_select "input[name=?]", "employee[name]"
      assert_select "input[name=?]", "employee[position]"
      assert_select "input[name=?]", "employee[salary]"
      assert_select "input[name=?]", "employee[date_of_birth]"
    end
  end

  it 'has navigation links' do
    render template: 'employees/edit'
    expect(rendered).to have_link('Back to Employees', href: employees_path)
  end
end 