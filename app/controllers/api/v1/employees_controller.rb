module Api
  module V1
    class EmployeesController < ApplicationController
      before_action :set_employee, only: [:show, :update, :destroy]
      
      def index
        pagy, employees = pagy(Employee.all)
        
        render json: {
         employees: employees.as_json(view: :index),
          meta: pagy_metadata(pagy)
        }
      end
      
      def show
        render json: @employee.as_json(view: :detail)
      end
      
      def create
        employee = Employee.new(employee_params)
        
        if employee.save
          render json: employee.as_json(view: :index), status: :created
        else
          render json: { 
            error: 'Validation failed',
            details: employee.errors.full_messages 
          }, status: :unprocessable_entity
        end
      end
      
      def update
        if @employee.update(employee_params)
          render json: @employee.as_json(view: :index)
        else
          render json: { 
            error: 'Validation failed',
            details: @employee.errors.full_messages 
          }, status: :unprocessable_entity
        end
      end
      
      def destroy
        @employee.destroy
        head :no_content
      end
      
      private
      
      def set_employee
        @employee = Employee.find(params[:id])
      end
      
      def employee_params
        params.require(:employee).permit(:first_name, :last_name, :job_title, :country_code, :gross_salary)
      end
    end
  end
end