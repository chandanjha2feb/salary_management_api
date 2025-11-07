class SalaryMetrics
  def self.by_country(country_code)
    country_code = country_code.upcase
    employees = Employee.where(country_code: country_code)
    
    return empty_response("No employees found for country: #{country_code}") if employees.empty?
    
    {
      country: country_code,
      currency: employees.first.currency_code,
      metrics: {
        min_salary: employees.minimum(:gross_salary).to_s,
        max_salary: employees.maximum(:gross_salary).to_s,
        avg_salary: employees.average(:gross_salary).round(2).to_f,
      }
    }
  end
  
  def self.by_job_title(job_title)
    # Case-insensitive search
    employees = Employee.where('LOWER(job_title) = ?', job_title.downcase)
    
    return empty_response("No employees found for job title: #{job_title}") if employees.empty?
    
    # Group by currency since different countries may have different currencies
    metrics_by_currency = employees.group(:currency_code).average(:gross_salary)
    
    {
      job_title: job_title,
      metrics: metrics_by_currency.transform_values { |v| v.round(2).to_f },
    }
  end
  
  private
  
  def self.empty_response(message)
    {
      message: message,
      metrics: nil
    }
  end
end