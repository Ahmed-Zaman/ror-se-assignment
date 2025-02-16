require 'net/http'
require 'json'

class EmployeeApiAdapter
  BASE_URL = 'https://dummy-employees-api-8bad748cda19.herokuapp.com/employees'.freeze

  def initialize
    @uri = URI(BASE_URL)
  end

  def fetch_employees(page = nil)
    uri = page ? URI("#{BASE_URL}?page=#{page}") : URI(BASE_URL)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def fetch_employee(id)
    uri = URI("#{BASE_URL}/#{id}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def create_employee(employee_params)
    uri = URI(BASE_URL)
    send_request(uri, :post, employee_params)
  end

  def update_employee(id, employee_params)
    uri = URI("#{BASE_URL}/#{id}")
    send_request(uri, :put, employee_params)
  end

  private

  def send_request(uri, method, body = nil)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')

    request = case method
              when :post then Net::HTTP::Post.new(uri.path)
              when :put then Net::HTTP::Put.new(uri.path)
              else raise ArgumentError, "Unsupported HTTP method: #{method}"
              end

    request['Content-Type'] = 'application/json'
    request.body = body.to_json

    response = http.request(request)
    JSON.parse(response.body)
  end
end
