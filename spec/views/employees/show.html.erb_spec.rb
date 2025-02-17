require 'rails_helper'

RSpec.describe "employees/show", type: :view do
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

  it 'displays employee details' do
    render
    expect(rendered).to match(/John Doe/)
    expect(rendered).to match(/Developer/)
    expect(rendered).to match(/75000/)
    expect(rendered).to match(/1990-01-01/)
  end

  it 'has navigation links' do
    render
    expect(rendered).to have_link('Edit Employee', href: edit_employee_path(employee["id"]))
    expect(rendered).to have_link('Back to Employees', href: employees_path)
  end
end 