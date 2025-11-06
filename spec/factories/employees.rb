# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    first_name { "John" }
    last_name { "Doe" }
    job_title { "Software Engineer" }
    country { "IN" }
    salary { 50000 }
  end
end
