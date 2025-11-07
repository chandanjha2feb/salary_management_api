FactoryBot.define do
  factory :tax_rate do
    country_code { 'IN' }
    tds_rate { 10.0 }
    active { true }

    trait :inactive do
      active { false }
    end
    
    trait :us do
      country_code { 'US' }
      tds_rate { 12.0 }
    end
    
    trait :india do
      country_code { 'IN' }
      tds_rate { 10.0 }
    end
  end
end
