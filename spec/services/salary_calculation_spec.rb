# spec/services/salary_calculation_service_spec.rb
require 'rails_helper'

RSpec.describe SalaryCalculation do
  describe '#calculate' do
    before do
      create(:tax_rate, country_code: 'IN', tds_rate: 10, active: true)
      create(:tax_rate, country_code: 'US', tds_rate: 12, active: true)
    end

    context 'for Indian employee' do
      let(:employee) do
        build(:employee, :indian)
      end

      it 'calculates correct deductions' do
        service = described_class.new(employee)
        result = service.calculate

        expect(result[:gross_salary]).to eq(50000)
        expect(result[:currency]).to eq('INR')
        expect(result[:deductions][:tds]).to eq(5000)
        expect(result[:deductions][:tds_rate]).to eq(10)
        expect(result[:net_salary]).to eq(45000)
      end
    end

    context 'for US employee' do
      let(:employee) do
        build(:employee, :american)
      end

      it 'calculates correct deductions' do
        service = described_class.new(employee)
        result = service.calculate

        expect(result[:gross_salary]).to eq(50000)
        expect(result[:currency]).to eq('USD')
        expect(result[:deductions][:tds]).to eq(6000)
        expect(result[:deductions][:tds_rate]).to eq(12)
        expect(result[:net_salary]).to eq(44000)
      end
    end

    context 'for country without tax rate' do
      let(:employee) do
        build(:employee, :british)
      end

      it 'applies zero deductions' do
        service = described_class.new(employee)
        result = service.calculate

        expect(result[:gross_salary]).to eq(50000)
        expect(result[:currency]).to eq('GBP')
        expect(result[:deductions][:tds]).to eq(0)
        expect(result[:deductions][:tds_rate]).to eq(0)
        expect(result[:net_salary]).to eq(50000)
      end
    end

    context 'with decimal amounts' do
      let(:employee) do
        build(:employee, :indian, gross_salary: 55555.55)
      end

      it 'handles decimal calculations correctly' do
        service = described_class.new(employee)
        result = service.calculate

        expect(result[:gross_salary]).to eq(55555.55)
        expect(result[:deductions][:tds]).to eq(5555.56)
        expect(result[:net_salary]).to eq(49999.99)
      end
    end
  end
end