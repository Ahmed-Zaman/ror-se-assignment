require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:mock_service) { instance_double(EmployeeService) }
  let(:employee_attributes) do
    {
      "name" => "John Doe",
      "position" => "Developer",
      "salary" => "75000",
      "date_of_birth" => "1990-01-01"
    }
  end
  
  before do
    sign_in user
    allow(EmployeeService).to receive(:new).and_return(mock_service)
  end

  describe 'GET #index' do
    let(:mock_employees) do
      {
        "data" => [
          { "id" => 1, "name" => "John Doe" },
          { "id" => 2, "name" => "Jane Smith" }
        ],
        "meta" => {
          "current_page" => 1,
          "total_pages" => 1
        }
      }
    end

    it 'assigns @employees and renders index' do
      allow(mock_service).to receive(:list_employees).and_return(mock_employees)
      get :index
      expect(assigns(:employees)).to eq(mock_employees)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let(:mock_employee) do
      { "id" => 1, "name" => "John Doe" }
    end

    it 'assigns @employee and renders show' do
      allow(mock_service).to receive(:get_employee).with("1").and_return(mock_employee)
      get :show, params: { id: 1 }
      expect(assigns(:employee)).to eq(mock_employee)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'renders new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    let(:mock_employee) do
      { "id" => 1, "name" => "John Doe" }
    end

    it 'assigns @employee and renders edit' do
      allow(mock_service).to receive(:get_employee).with("1").and_return(mock_employee)
      get :edit, params: { id: 1 }
      expect(assigns(:employee)).to eq(mock_employee)
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new employee and redirects' do
        expect(mock_service).to receive(:create_employee)
          .with(employee_attributes)
          .and_return({ "id" => 1, "name" => "John Doe" })

        post :create, params: { employee: employee_attributes }
        expect(response).to redirect_to(employees_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { "name" => "" } }

      it 'renders new template' do
        expect(mock_service).to receive(:create_employee)
          .with(invalid_attributes)
          .and_raise(StandardError.new("Invalid data"))

        post :create, params: { employee: invalid_attributes }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the employee and redirects' do
        allow(mock_service).to receive(:update_employee)
          .with("1", employee_attributes)
          .and_return({ "id" => 1, "name" => "John Doe" })

        put :update, params: { 
          id: 1, 
          employee: employee_attributes
        }
        
        expect(response).to redirect_to(employees_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { "name" => "" } }

      it 'renders edit template' do
        expect(mock_service).to receive(:update_employee)
          .with("1", invalid_attributes)
          .and_raise(StandardError.new("Invalid data"))

        put :update, params: { id: 1, employee: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to be_present
      end
    end
  end
end 