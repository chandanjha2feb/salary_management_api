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

	describe 'callbacks' do
		describe 'before_validation' do
			it 'sets currency code based on country' do
				employee = build(:employee)
				employee.valid?
				expect(employee.currency_code).to eq('INR')
			end

			it 'uses USD as default currency for unknown countries' do
				employee = build(:employee, country_code: 'INVALID')
				employee.valid?
				expect(employee.currency_code).to eq('USD')
			end

			it 'does not override manually set currency' do
				employee = build(:employee, currency_code: 'USD')
				employee.valid?
				expect(employee.currency_code).to eq('USD')
			end
		end
	end

	describe 'helper methods' do
		let(:employee) { build(:employee) }

		it 'returns country object' do
			expect(employee.country).to be_a(ISO3166::Country)
			expect(employee.country_name).to eq('India')
		end

		it 'returns country name' do
			expect(employee.country_name).to eq('India')
		end
	end

	describe 'salary calculation on save' do
		before do
			create(:tax_rate, country_code: 'IN', tds_rate: 10, active: true)
			create(:tax_rate, country_code: 'US', tds_rate: 12, active: true)
		end

		it 'calculates net salary before save' do
			employee = build(:employee, country_code: 'IN', gross_salary: 100000)
			employee.save!
			
			expect(employee.net_salary).to eq(90000)
			expect(employee.tds_amount).to eq(10000)
			expect(employee.deductions_breakdown).to eq({
				'tds' => 10000.0,
				'tds_rate' => 10.0
			})
		end

		it 'recalculates when gross salary changes' do
			employee = create(:employee, country_code: 'IN', gross_salary: 100000)
			expect(employee.net_salary).to eq(90000)
			
			employee.update!(gross_salary: 50000)
			expect(employee.net_salary).to eq(45000)
			expect(employee.tds_amount).to eq(5000)
		end

		it 'recalculates when country changes' do
			employee = create(:employee, country_code: 'IN', gross_salary: 100000)
			expect(employee.net_salary).to eq(90000)
			
			employee.update!(country_code: 'US', currency_code: 'USD')
			expect(employee.net_salary).to eq(88000)
			expect(employee.tds_amount).to eq(12000)
		end
	end
end