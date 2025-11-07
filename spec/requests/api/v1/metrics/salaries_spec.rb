require 'rails_helper'

RSpec.describe 'Api::V1::Metrics::Salaries', type: :request do
  before do
    create(:tax_rate, :india)
    create(:tax_rate, :us)
  end

  describe 'GET /api/v1/metrics/salaries/by_country' do
    context 'with employees in the country' do
      before do
        create(:employee, country_code: 'IN', gross_salary: 50000)
        create(:employee, country_code: 'IN', gross_salary: 60000)
        create(:employee, country_code: 'IN', gross_salary: 70000)
        create(:employee, country_code: 'US', gross_salary: 80000)
      end

      it 'returns salary metrics for the country' do
        get '/api/v1/metrics/salaries/by_country', params: { country: 'IN' }
        
        expect(response).to have_http_status(:success)
        
        json = JSON.parse(response.body)
        expect(json['country']).to eq('IN')
        expect(json['currency']).to eq('INR')
        expect(json['metrics']).to include(
          'min_salary' => '50000.0',
          'max_salary' => '70000.0',
          'avg_salary' => 60000.0,
          'employee_count' => 3
        )
      end

      it 'handles case-insensitive country codes' do
        get '/api/v1/metrics/salaries/by_country', params: { country: 'in' }
        
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['country']).to eq('IN')
      end
    end

    context 'with no employees in the country' do
      it 'returns not found with meaningful message' do
        get '/api/v1/metrics/salaries/by_country', params: { country: 'GB' }
        
        expect(response).to have_http_status(:not_found)
        
        json = JSON.parse(response.body)
        expect(json['message']).to eq('No employees found for country: GB')
        expect(json['metrics']).to be_nil
      end
    end

    context 'without country parameter' do
      it 'returns bad request' do
        get '/api/v1/metrics/salaries/by_country'
        
        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Country parameter is required')
      end
    end
  end

  describe 'GET /api/v1/metrics/salaries/by_job_title' do
    before do
      create(:employee, job_title: 'Engineer', country_code: 'IN', gross_salary: 50000)
      create(:employee, job_title: 'Engineer', country_code: 'IN', gross_salary: 60000)
      create(:employee, job_title: 'Engineer', country_code: 'US', gross_salary: 80000)
      create(:employee, job_title: 'Manager', gross_salary: 90000)
    end

    context 'with employees having the job title' do
      it 'returns salary metrics grouped by currency' do
        get '/api/v1/metrics/salaries/by_job_title', params: { job_title: 'Engineer' }
        
        expect(response).to have_http_status(:success)
        
        json = JSON.parse(response.body)
        expect(json['job_title']).to eq('Engineer')
        expect(json['metrics']).to include(
          'INR' => 55000.0,  # Average of 50000 and 60000
          'USD' => 80000.0
        )
        expect(json['employee_count']).to eq(3)
      end

      it 'handles case-insensitive job titles' do
        get '/api/v1/metrics/salaries/by_job_title', params: { job_title: 'engineer' }
        
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['job_title']).to eq('engineer')
      end
    end

    context 'with no employees having the job title' do
      it 'returns not found with meaningful message' do
        get '/api/v1/metrics/salaries/by_job_title', params: { job_title: 'CEO' }
        
        expect(response).to have_http_status(:not_found)
        
        json = JSON.parse(response.body)
        expect(json['message']).to eq('No employees found for job title: CEO')
        expect(json['metrics']).to be_nil
      end
    end

    context 'without job_title parameter' do
      it 'returns bad request' do
        get '/api/v1/metrics/salaries/by_job_title'
        
        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Job title parameter is required')
      end
    end
  end
end