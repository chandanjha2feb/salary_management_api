# spec/models/employee_spec.rb
require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'model setup' do
    it 'exists' do
      expect(described_class).to be_present
    end
  end

  describe 'validations' do
    describe 'first_name' do
      it 'is required' do
        employee = Employee.new(first_name: nil)
        employee.valid?
        expect(employee.errors[:first_name]).to include("can't be blank")
      end

      it 'must have minimum 2 characters' do
        employee = Employee.new(first_name: 'A')
        employee.valid?
        expect(employee.errors[:first_name]).to include('is too short (minimum is 2 characters)')
      end
    end

    describe 'last_name' do
      it 'is required' do
        employee = Employee.new(last_name: nil)
        employee.valid?
        expect(employee.errors[:last_name]).to include("can't be blank")
      end

      it 'must have minimum 2 characters' do
        employee = Employee.new(last_name: 'A')
        employee.valid?
        expect(employee.errors[:last_name]).to include('is too short (minimum is 2 characters)')
      end
    end

    describe 'job_title' do
      it 'is required' do
        employee = Employee.new(job_title: nil)
        employee.valid?
        expect(employee.errors[:job_title]).to include("can't be blank")
      end
    end

    describe 'country_code' do
      it 'is required' do
        employee = Employee.new(country_code: nil)
        employee.valid?
        expect(employee.errors[:country_code]).to include("can't be blank")
      end

      it 'must be a valid ISO country code' do
        employee = Employee.new(country_code: 'INVALID')
        employee.valid?
        expect(employee.errors[:country_code]).to include('is not a valid country code')
      end
    end

    describe 'gross_salary' do
      it 'is required' do
        employee = Employee.new(gross_salary: nil)
        employee.valid?
        expect(employee.errors[:gross_salary]).to include("can't be blank")
      end

      it 'must be greater than zero' do
        employee = Employee.new(gross_salary: 0)
        employee.valid?
        expect(employee.errors[:gross_salary]).to include('must be greater than 0')
      end

      it 'cannot be negative' do
        employee = Employee.new(gross_salary: -1000)
        employee.valid?
        expect(employee.errors[:gross_salary]).to include('must be greater than 0')
      end
    end
  end
end