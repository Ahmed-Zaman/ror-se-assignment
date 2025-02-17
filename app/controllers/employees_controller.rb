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
    @employee = @employee_service.create_employee(employee_params.to_h)
    redirect_to employees_path, notice: 'Employee was successfully created.'
  rescue StandardError => e
    flash.now[:alert] = e.message
    render :new
  end

  def update
    @employee = @employee_service.update_employee(params[:id], employee_params.to_h)
    redirect_to employees_path, notice: 'Employee was successfully updated.'
  rescue StandardError => e
    flash.now[:alert] = e.message
    render :edit
  end

  private

  def initialize_service
    @employee_service ||= EmployeeService.new
  end

  def employee_params
    params.require(:employee).permit(:name, :position, :salary, :date_of_birth)
  end
end
