FactoryBot.define do
  factory :tax_rate do
    country_code { 'IN' }
    tds_rate { 10.0 }
    active { true }
  end
end
