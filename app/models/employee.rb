class Employee < ApplicationRecord
  validates :first_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :job_title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :country_code, presence: true
  validates :gross_salary, presence: true, 
            numericality: { greater_than: 0 }
  
  validate :valid_country_code
  
  private
  
  def valid_country_code
    return if country_code.blank?
    
    unless ISO3166::Country[country_code]
      errors.add(:country_code, 'is not a valid country code')
    end
  end
end