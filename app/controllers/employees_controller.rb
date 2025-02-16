class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_service

  def index
    @employees = @employee_service.list_employees(params[:page])
  end

  def edit
    @employee = @employee_service.get_employee(params[:id])
  end

  def show
    @employee = @employee_service.get_employee(params[:id])
  end

  def create
    employee_params = {
      name: params[:name],
      position: params[:position],
      date_of_birth: params[:date_of_birth],
      salary: params[:salary]
    }
    @employee = @employee_service.create_employee(employee_params)
    redirect_to employee_path(@employee.dig('id'))
  end

  def update
    employee_params = {
      name: params[:name],
      position: params[:position],
      date_of_birth: params[:date_of_birth],
      salary: params[:salary]
    }
    @employee = @employee_service.update_employee(params[:id], employee_params)
    redirect_to edit_employee_path(@employee.dig('id'))
  end

  private

  def initialize_service
    @employee_service ||= EmployeeService.new
  end
end
