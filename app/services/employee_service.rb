class EmployeeService
    def initialize(adapter: EmployeeApiAdapter.new)
      @adapter = adapter
    end
  
    def list_employees(page = nil)
      @adapter.fetch_employees(page)
    end
  
    def get_employee(id)
      @adapter.fetch_employee(id)
    end
  
    def create_employee(employee_params)
      @adapter.create_employee(employee_params)
    end
  
    def update_employee(id, employee_params)
      @adapter.update_employee(id, employee_params)
    end
  end
  