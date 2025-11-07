module Api
  module V1
    class EmployeesController < ApplicationController
      def index
        pagy, employees = pagy(Employee.all)
        
        render json: {
          employees: employees.as_json(
            only: [:id, :first_name, :last_name, :job_title, :country_code, :currency_code],
            methods: [:gross_salary, :net_salary]
          ),
          meta: pagy_metadata(pagy)
        }
      end
    end
  end
end