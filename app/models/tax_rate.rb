# app/models/tax_rate.rb
class TaxRate < ApplicationRecord
  validates :country_code, presence: true
  validates :tds_rate, presence: true, 
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  
  scope :active, -> { where(active: true) }
  scope :for_country, ->(code) { active.where(country_code: code.upcase) }
  
  def self.rate_for(country_code)
    for_country(country_code).first&.tds_rate || 0
  end
end