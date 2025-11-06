# spec/models/employee_spec.rb
require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'model setup' do
    it 'exists' do
      expect(described_class).to be_present
    end
  end
end