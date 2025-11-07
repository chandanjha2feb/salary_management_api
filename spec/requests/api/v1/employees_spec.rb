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
        data = jsonapi_data(response.body)
        expect(data.size).to eq(3)
      end

      it 'includes employee details' do
        get '/api/v1/employees'

        data = jsonapi_data(response.body)
        first_employee_resource = data.first
        first_employee_attrs = jsonapi_attributes(first_employee_resource)

        expect(first_employee_attrs).to include(
          'id' => employees.first.id,
          'full_name' => 'John Doe',
          'job_title' => employees.first.job_title,
          'country' => employees.first.country_name,
          'currency' => employees.first.currency_code,
          'net_salary' => employees.first.net_salary.to_s,
          'tds_percentage' => employees.first.tds_percentage,
        )
      end

      it 'includes pagination metadata' do
        get '/api/v1/employees'

        meta = jsonapi_meta(response.body)
        expect(meta).to include(
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
        data = jsonapi_data(response.body)
        expect(data).to eq([])
      end
    end

    context 'with pagination' do
      before do
        25.times { create(:employee) }
      end

      it 'paginates results' do
        get '/api/v1/employees', params: { page: 2 }

        data = jsonapi_data(response.body)
        meta = jsonapi_meta(response.body)
        expect(meta['current_page']).to eq(2)
        expect(data.size).to eq(5) # 25 total, 20 per page, so 5 on page 2
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

        attrs = jsonapi_attributes_from_body(response.body)
        expect(attrs['full_name']).to eq('John Doe')
        expect(attrs['job_title']).to eq('Software Engineer')
        expect(attrs['net_salary']).to eq('45000.0')
        expect(attrs['gross_salary']).to eq('50000.0')
        expect(attrs['deductions']).to eq('5000.0')
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
        errors = jsonapi_errors(response.body)
        error_messages = errors.map { |e| e['detail'] }
        expect(error_messages).to include(
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
        errors = jsonapi_errors(response.body)
        error_messages = errors.map { |e| e['detail'] }
        expect(error_messages).to include('Gross salary must be greater than 0')
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