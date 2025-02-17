require 'rails_helper'

RSpec.describe EmployeeService do
  let(:service) { described_class.new }
  let(:mock_adapter) { instance_double(EmployeeApiAdapter) }

  before do
    allow(EmployeeApiAdapter).to receive(:new).and_return(mock_adapter)
  end

  describe '#list_employees' do
    let(:mock_response) do
      {
        "data" => [
          { "id" => 1, "name" => "John Doe" }
        ],
        "meta" => { "current_page" => 1 }
      }
    end

    it 'fetches employees with pagination' do
      expect(mock_adapter).to receive(:fetch_employees)
        .with(2)
        .and_return(mock_response)

      result = service.list_employees(2)
      expect(result).to eq(mock_response)
    end
  end
end 