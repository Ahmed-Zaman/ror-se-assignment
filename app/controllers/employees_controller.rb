# require 'net/http'
# require 'net/https'

# class EmployeesController < ApplicationController
#   before_action :authenticate_user!
  
#     def index
#       if params[:page].present?
#         uri = URI("https://dummy-employees-api-8bad748cda19.herokuapp.com/employees?page=#{params[:page]}")
#       else
#         uri = URI('https://dummy-employees-api-8bad748cda19.herokuapp.com/employees')
#       end
#       @response = Net::HTTP.get(uri)
#       @employees = JSON.parse(@response)
#     end
  
#     def edit
#       uri = URI("https://dummy-employees-api-8bad748cda19.herokuapp.com/employees/#{params[:id]}")
#       @response = Net::HTTP.get(uri)
#       @employee = JSON.parse(@response)
#     end

#     def show
#       uri = URI("https://dummy-employees-api-8bad748cda19.herokuapp.com/employees/#{params[:id]}")
#       @response = Net::HTTP.get(uri)
#       @employee = JSON.parse(@response)
#     end

#     def create
#       uri = URI("https://dummy-employees-api-8bad748cda19.herokuapp.com/employees/#{params[:id]}")


#       http = Net::HTTP.new(uri.host, uri.port)

#       http.use_ssl = (uri.scheme == 'https')

#       request = Net::HTTP::Post.new(uri.path)

#       request['Content-Type'] = 'application/json'

#       body = {
#         "name": params[:name],
#         "position": params[:position],
#         "date_of_birth": params[:date_of_birth],
#         "salary": params[:salary]
#       }.to_json
#       request.body = body

#       response = http.request(request)

#       puts "Response Code: #{response.code}"
#       puts "Response Body: #{response.body}"

#       @employee = JSON.parse(response.body)

#       redirect_to employee_path(@employee.dig("id"))
#     end
  
#     def update

#       uri = URI("https://dummy-employees-api-8bad748cda19.herokuapp.com/employees/#{params[:id]}")


#       http = Net::HTTP.new(uri.host, uri.port)

#       http.use_ssl = (uri.scheme == 'https')

#       request = Net::HTTP::Put.new(uri.path)

#       request['Content-Type'] = 'application/json'

#       body = {
#         "name": params[:name],
#         "position": params[:position],
#         "date_of_birth": params[:date_of_birth],
#         "salary": params[:salary]
#       }.to_json
#       request.body = body

#       response = http.request(request)

#       puts "Response Code: #{response.code}"
#       puts "Response Body: #{response.body}"

#       @employee = JSON.parse(response.body)

#       redirect_to edit_employee_path(@employee.dig("id"))
#     end  
# end


# app/controllers/employees_controller.rb
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
    @employee_service = EmployeeService.new
  end
end
