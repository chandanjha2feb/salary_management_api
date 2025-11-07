require 'rails_helper'

RSpec.describe 'Api::V1::Employees', type: :request do
  describe 'GET /api/v1/employees' do
    before do
      create(:tax_rate, :india)
      create(:tax_rate, :us)
    end

    context 'when employees exist' do
      let!(:employees) do
        [
          create(:employee, :indian),
          create(:employee, :american),
          create(:employee, :british)
        ]
      end

      it 'returns all employees' do
        get '/api/v1/employees'
        
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['employees'].size).to eq(3)
      end

      it 'includes employee details' do
        get '/api/v1/employees'
        
        json = JSON.parse(response.body)
        first_employee = json['employees'].first
        
        expect(first_employee).to include(
          'id' => employees.first.id,
          'first_name' => employees.first.first_name,
          'last_name' => employees.first.last_name,
          'job_title' => employees.first.job_title,
          'country_code' => employees.first.country_code,
          'currency_code' => employees.first.currency_code,
          'gross_salary' => employees.first.gross_salary.to_s,
          'net_salary' => employees.first.net_salary.to_s
        )
      end

      it 'includes pagination metadata' do
        get '/api/v1/employees'
        
        json = JSON.parse(response.body)
        expect(json).to have_key('meta')
        expect(json['meta']).to include(
          'current_page' => 1,
          'total_pages' => 1,
          'total_count' => 3
        )
      end
    end

    context 'when no employees exist' do
      it 'returns empty array' do
        get '/api/v1/employees'
        
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['employees']).to eq([])
      end
    end

    context 'with pagination' do
      before do
        25.times { create(:employee) }
      end

      it 'paginates results' do
        get '/api/v1/employees', params: { page: 2 }
        
        json = JSON.parse(response.body)
        expect(json['meta']['current_page']).to eq(2)
        expect(json['employees'].size).to eq(5) # 25 total, 20 per page, so 5 on page 2
      end
    end
  end
end