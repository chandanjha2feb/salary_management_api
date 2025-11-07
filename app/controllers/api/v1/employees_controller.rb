module Api
  module V1
    class EmployeesController < ApplicationController
      before_action :set_employee, only: [:show, :update, :destroy]

      def index
        pagy, employees = pagy(Employee.all)

        serialized = EmployeeSerializer.new(employees, options(:index)).serializable_hash

        render json: serialized.merge(meta: pagy_metadata(pagy))
      end

      def show
        render json: EmployeeSerializer.new(@employee, options(:detail)).serializable_hash
      end

      def create
        employee = Employee.new(employee_params)

        if employee.save
          render json: EmployeeSerializer.new(employee, options(:detail)).serializable_hash, status: :created
        else
          render json: {
            errors: employee.errors.full_messages.map { |msg| { detail: msg } }
          }, status: :unprocessable_entity
        end
      end

      def update
        if @employee.update(employee_params)
          render json: EmployeeSerializer.new(@employee, options(:detail)).serializable_hash
        else
          render json: {
            errors: @employee.errors.full_messages.map { |msg| { detail: msg } }
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @employee.destroy
        head :no_content
      end

      private

      def options(view)
        { params: { view: view } }
      end

      def set_employee
        @employee = Employee.find(params[:id])
      end

      def employee_params
        params.require(:employee).permit(:first_name, :last_name, :job_title, :country_code, :gross_salary)
      end
    end
  end
end