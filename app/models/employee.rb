class Employee < ApplicationRecord
	MINIMUM_LENGTH = 2
	MAXIMUM_LENGTH = 100

  validates :first_name, presence: true, length: { minimum: MINIMUM_LENGTH, maximum: MAXIMUM_LENGTH }
  validates :last_name, presence: true, length: { minimum: MINIMUM_LENGTH, maximum: MAXIMUM_LENGTH }
  validates :job_title, presence: true, length: { minimum: MINIMUM_LENGTH, maximum: MAXIMUM_LENGTH }
  validates :country_code, presence: true
  validates :gross_salary, presence: true, 
            numericality: { greater_than: 0 }
  
  validate :valid_country_code

	before_validation :set_currency_from_country

	def country
    ISO3166::Country[country_code]
  end
  
  def country_name
    country&.common_name
  end
  
  private
  
  def valid_country_code
    return if country_code.blank?
    
    unless ISO3166::Country[country_code]
      errors.add(:country_code, 'is not a valid country code')
    end
  end

	def set_currency_from_country
    return if currency_code.present?
    
    if country
			self.currency_code = country.currency_code || 'USD'    
		else
      self.currency_code = 'USD'
    end
  end
end