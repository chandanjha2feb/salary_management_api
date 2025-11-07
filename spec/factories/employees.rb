# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    first_name { "John" }
    last_name { "Doe" }
    job_title { "Software Engineer" }
    country_code { "IN" }
    currency_code { nil }
    gross_salary { 50000 }
    net_salary { 40000 }
    tds_percentage { 10 }
    deductions { 1000 }
  end
end
