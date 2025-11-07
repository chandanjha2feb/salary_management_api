# spec/models/tax_rate_spec.rb
require 'rails_helper'

RSpec.describe TaxRate, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      tax_rate = TaxRate.new(
        country_code: 'IN',
        tds_rate: 10.0,
        active: true
      )
      expect(tax_rate).to be_valid
    end

    it 'requires country_code' do
      tax_rate = TaxRate.new(country_code: nil, tds_rate: 10)
      expect(tax_rate).not_to be_valid
      expect(tax_rate.errors[:country_code]).to include("can't be blank")
    end

    it 'requires tds_rate' do
      tax_rate = TaxRate.new(country_code: 'IN', tds_rate: nil)
      expect(tax_rate).not_to be_valid
      expect(tax_rate.errors[:tds_rate]).to include("can't be blank")
    end

    it 'validates tds_rate is between 0 and 100' do
      tax_rate = TaxRate.new(country_code: 'IN', tds_rate: -1)
      expect(tax_rate).not_to be_valid
      expect(tax_rate.errors[:tds_rate]).to include('must be greater than or equal to 0')

      tax_rate = TaxRate.new(country_code: 'IN', tds_rate: 101)
      expect(tax_rate).not_to be_valid
      expect(tax_rate.errors[:tds_rate]).to include('must be less than or equal to 100')
    end
  end

  describe 'scopes' do
    before do
      create(:tax_rate, :india)
      create(:tax_rate, :us)
      create(:tax_rate, :inactive)
    end

    describe '.active' do
      it 'returns only active tax rates' do
        expect(TaxRate.active.count).to eq(2)
        expect(TaxRate.active.pluck(:country_code)).to contain_exactly('IN', 'US')
      end
    end

    describe '.for_country' do
      it 'returns tax rate for specific country' do
        result = TaxRate.for_country('IN')
        expect(result.count).to eq(1)
        expect(result.first.tds_rate).to eq(10)
      end

      it 'handles case-insensitive country codes' do
        result = TaxRate.for_country('in')
        expect(result.count).to eq(1)
        expect(result.first.country_code).to eq('IN')
      end
    end
  end

  describe '.rate_for' do
    before do
      create(:tax_rate, :india)
      create(:tax_rate, :us)
    end

    it 'returns the rate for a country' do
      expect(TaxRate.rate_for('IN')).to eq(10)
      expect(TaxRate.rate_for('US')).to eq(12)
    end

    it 'returns 0 for countries without tax rates' do
      expect(TaxRate.rate_for('GB')).to eq(0)
    end

    it 'handles case-insensitive input' do
      expect(TaxRate.rate_for('in')).to eq(10)
    end
  end
end