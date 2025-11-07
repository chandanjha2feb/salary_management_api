puts "🌱 Starting seed process..."

puts "🧹 Cleaning up existing data..."
Employee.destroy_all
TaxRate.destroy_all

# ============================================
# Tax Rates
# ============================================
puts "📊 Creating tax rates..."

tax_rates_data = [
    { country_code: 'IN', tds_rate: 10.0, active: true },   
    { country_code: 'US', tds_rate: 12.0, active: true },   
    { country_code: 'GB', tds_rate: 20.0, active: true },   
    { country_code: 'CA', tds_rate: 15.0, active: true },   
    { country_code: 'AU', tds_rate: 18.0, active: true },   
    { country_code: 'DE', tds_rate: 25.0, active: true },   
    { country_code: 'FR', tds_rate: 22.0, active: true },
    { country_code: 'JP', tds_rate: 16.0, active: true },   
    { country_code: 'SG', tds_rate: 8.0, active: true },   
    { country_code: 'BR', tds_rate: 14.0, active: true },   
]

tax_rates_data.each do |data|
TaxRate.create!(data)
end

puts "✅ Created #{TaxRate.count} tax rates"

# ============================================
# Employees
# ============================================
puts "👥 Creating employees..."

employees_data = [
    # Indian Employees
    { first_name: 'Rajesh', last_name: 'Kumar', job_title: 'Senior Software Engineer', country_code: 'IN', gross_salary: 120000 },
    { first_name: 'Priya', last_name: 'Sharma', job_title: 'Product Manager', country_code: 'IN', gross_salary: 150000 },
    { first_name: 'Amit', last_name: 'Patel', job_title: 'DevOps Engineer', country_code: 'IN', gross_salary: 95000 },
    { first_name: 'Sneha', last_name: 'Reddy', job_title: 'Data Scientist', country_code: 'IN', gross_salary: 110000 },

    # US Employees
    { first_name: 'John', last_name: 'Smith', job_title: 'Engineering Manager', country_code: 'US', gross_salary: 180000 },
    { first_name: 'Sarah', last_name: 'Johnson', job_title: 'UX Designer', country_code: 'US', gross_salary: 95000 },
    { first_name: 'Michael', last_name: 'Brown', job_title: 'Backend Developer', country_code: 'US', gross_salary: 125000 },
    { first_name: 'Emily', last_name: 'Davis', job_title: 'Frontend Developer', country_code: 'US', gross_salary: 115000 },

    # UK Employees
    { first_name: 'James', last_name: 'Wilson', job_title: 'Solutions Architect', country_code: 'GB', gross_salary: 85000 },
    { first_name: 'Emma', last_name: 'Taylor', job_title: 'QA Engineer', country_code: 'GB', gross_salary: 65000 },
    { first_name: 'Oliver', last_name: 'Anderson', job_title: 'Technical Lead', country_code: 'GB', gross_salary: 95000 },

    # Canadian Employees
    { first_name: 'Sophie', last_name: 'Martin', job_title: 'Full Stack Developer', country_code: 'CA', gross_salary: 105000 },
    { first_name: 'Lucas', last_name: 'Dubois', job_title: 'Backend Developer', country_code: 'CA', gross_salary: 115000 },

    # Australian Employees
    { first_name: 'Liam', last_name: 'Murphy', job_title: 'Mobile Developer', country_code: 'AU', gross_salary: 98000 },
    { first_name: 'Olivia', last_name: 'Chen', job_title: 'Cloud Engineer', country_code: 'AU', gross_salary: 108000 },

    # German Employees
    { first_name: 'Hans', last_name: 'Mueller', job_title: 'Database Administrator', country_code: 'DE', gross_salary: 75000 },
    { first_name: 'Anna', last_name: 'Schmidt', job_title: 'Backend Developer', country_code: 'DE', gross_salary: 68000 },

    # French Employees
    { first_name: 'Pierre', last_name: 'Dubois', job_title: 'System Administrator', country_code: 'FR', gross_salary: 62000 },
    { first_name: 'Marie', last_name: 'Bernard', job_title: 'Frontend Developer', country_code: 'FR', gross_salary: 70000 },

    # Japanese Employees
    { first_name: 'Yuki', last_name: 'Tanaka', job_title: 'AI Engineer', country_code: 'JP', gross_salary: 92000 },
    { first_name: 'Haruto', last_name: 'Sato', job_title: 'Backend Developer', country_code: 'JP', gross_salary: 78000 },

    # Singapore Employees
    { first_name: 'Wei', last_name: 'Tan', job_title: 'Site Reliability Engineer', country_code: 'SG', gross_salary: 105000 },
    { first_name: 'Mei', last_name: 'Lim', job_title: 'Software Architect', country_code: 'SG', gross_salary: 135000 },

    # Brazilian Employees
    { first_name: 'Carlos', last_name: 'Silva', job_title: 'Platform Engineer', country_code: 'BR', gross_salary: 55000 },
    { first_name: 'Ana', last_name: 'Santos', job_title: 'Backend Developer', country_code: 'BR', gross_salary: 48000 },
]

employees_data.each do |data|
    Employee.create!(data)
end

puts "✅ Created #{Employee.count} employees"

# ============================================
# Summary
# ============================================
puts "\n📈 Seed Summary:"
puts "=" * 50
puts "Tax Rates: #{TaxRate.count}"
puts "Employees: #{Employee.count}"
puts "\nEmployees by country:"
Employee.group(:country_code).count.sort_by { |k, v| -v }.each do |country, count|
country_name = ISO3166::Country[country]&.common_name || country
puts "  #{country_name} (#{country}): #{count}"
end
puts "\n✨ Seeding complete!"