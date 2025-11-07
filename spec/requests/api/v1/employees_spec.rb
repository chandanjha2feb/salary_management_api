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
          'full_name' => employees.first.full_name,
          'job_title' => employees.first.job_title,
          'country' => employees.first.country_name,
          'currency' => employees.first.currency_code,
          'net_salary' => employees.first.net_salary.to_s,
          'tds_percentage' => employees.first.tds_percentage,
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

  describe 'POST /api/v1/employees' do
		before do
			create(:tax_rate, :india)
		end

		context 'with valid parameters' do
			let(:valid_params) do
				{
					employee: {
						first_name: 'John',
						last_name: 'Doe',
						job_title: 'Software Engineer',
						country_code: 'IN',
						gross_salary: 50000.00
					}
				}
			end

			it 'creates a new employee' do
				expect {
					post '/api/v1/employees', params: valid_params
				}.to change(Employee, :count).by(1)
				
				expect(response).to have_http_status(:created)
			end

			it 'returns the created employee with calculated salary' do
				post '/api/v1/employees', params: valid_params
				
				json = JSON.parse(response.body)
				expect(json['full_name']).to eq('John Doe')
				expect(json['job_title']).to eq('Software Engineer')
				expect(json['net_salary']).to eq('45000.0')
			end
  	end

		context 'with invalid parameters' do
			let(:invalid_params) do
				{
					employee: {
						first_name: '',
						last_name: '',
						job_title: '',
						country_code: '',
						gross_salary: 0
					}
				}
			end

			it 'does not create employee' do
				expect {
					post '/api/v1/employees', params: invalid_params
				}.not_to change(Employee, :count)
			end

			it 'returns validation errors' do
				post '/api/v1/employees', params: invalid_params
				
				expect(response).to have_http_status(:unprocessable_entity)
				json = JSON.parse(response.body)
				expect(json['error']).to eq('Validation failed')
				expect(json['details']).to include(
					"First name can't be blank",
					"Last name can't be blank",
					"Job title can't be blank",
					"Country code can't be blank",
					"Gross salary must be greater than 0"
				)
			end
		end
	end

	describe 'PUT /api/v1/employees/:id' do
		before do
			create(:tax_rate, :india)
			create(:tax_rate, :us)
		end
		
		let(:employee) { create(:employee, country_code: 'IN', gross_salary: 50000) }
		
		context 'with valid parameters' do
			let(:valid_params) do
				{
					employee: {
						gross_salary: 60000.00
					}
				}
			end

			it 'updates the employee' do
				put "/api/v1/employees/#{employee.id}", params: valid_params
				
				expect(response).to have_http_status(:success)
				employee.reload
				expect(employee.gross_salary).to eq(60000)
				expect(employee.net_salary).to eq(54000) # Recalculated
			end
		end

		context 'with invalid parameters' do
			let(:invalid_params) do
				{
					employee: {
						gross_salary: -1000
					}
				}
			end

			it 'returns validation errors' do
				put "/api/v1/employees/#{employee.id}", params: invalid_params
				
				expect(response).to have_http_status(:unprocessable_entity)
				json = JSON.parse(response.body)
				expect(json['details']).to include('Gross salary must be greater than 0')
			end
		end
	end

	describe 'DELETE /api/v1/employees/:id' do
		let!(:employee) { create(:employee) }
		
		it 'deletes the employee' do
			expect {
				delete "/api/v1/employees/#{employee.id}"
			}.to change(Employee, :count).by(-1)
			
			expect(response).to have_http_status(:no_content)
		end
		
		it 'returns 404 for non-existent employee' do
			delete '/api/v1/employees/999999'
			
			expect(response).to have_http_status(:not_found)
		end
	end
end