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
	before_save :calculate_net_salary

	BASIC_FIELDS = %i[
    id job_title net_salary tds_percentage
  ].freeze

	# Use :view => :index (default) or :detail (adds tds_amount)
  def serializable_hash(options = nil)
    options ||= {}
    view = options[:view] || :index

    base = super({ only: BASIC_FIELDS }.merge(options))
    base.merge!(
      "full_name" => full_name,
      "country"   => country_name,
      "currency"  => currency_code
    )

		if view == :detail
    	base["tds_percentage"] = tds_percentage
			base["deductions"] = deductions
			base["gross_salary"] = gross_salary
		end

    base
  end

	def full_name
		"#{first_name} #{last_name}"
	end

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

	def calculate_net_salary
    return unless gross_salary.present?
    
    calculator = ::SalaryCalculation.new(self)
    result = calculator.calculate
    
    self.tds_percentage = result[:deductions][:tds_rate]
    self.net_salary = result[:net_salary]
    self.deductions = result[:deductions][:tds]
  end
end