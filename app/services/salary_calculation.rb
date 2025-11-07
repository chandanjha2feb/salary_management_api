# app/services/salary_calculation_service.rb
class SalaryCalculation
  attr_reader :employee

  def initialize(employee)
    @employee = employee
  end

  def calculate
    gross = employee.gross_salary.to_f
    tds_rate = TaxRate.rate_for(employee.country_code).to_f
    tds_amount = (gross * tds_rate / 100).round(2)
    net = (gross - tds_amount).round(2)

    {
      gross_salary: gross,
      currency: employee.currency_code,
      deductions: {
        tds: tds_amount,
        tds_rate: tds_rate
      },
      net_salary: net
    }
  end
end