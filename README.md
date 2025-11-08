# README.md

# Salary Management API

A production-ready REST API for managing employee salaries with country-specific tax calculations, built using Ruby on Rails with Test-Driven Development (TDD).

## 🚀 Features

- **Employee CRUD Operations**: Create, read, update, and delete employee records
- **Automatic Salary Calculations**: Country-specific tax deductions (TDS)
- **Multi-Currency Support**: Automatic currency assignment based on country
- **Salary Metrics**: Analytics by country and job title
- **Pagination**: Efficient data retrieval for large datasets
- **Error Handling**: Comprehensive error messages with proper HTTP status codes

## 📋 Requirements

- Ruby 3.4.2
- Rails 8.1.1
- SQLite3
- Bundler 2.6.2

## 🛠️ Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/salary_management_api.git
cd salary_management_api
```

2. Install dependencies:
```bash
bundle install
```

3. Set up the database:
```bash
rails db:create
rails db:migrate
rails db:seed  # Seeds initial tax rates
```

4. Run the test suite to ensure everything is working:
```bash
bundle exec rspec
```

5. Start the server:
```bash
rails server
```

The API will be available at `http://localhost:3000`

## 🔑 Key Design Decisions

1. **API Versioning**: Using URL-based versioning (`/api/v1/`) for clear version management
2. **Service Objects**: Business logic separated into service classes for maintainability
3. **Currency Handling**: Using `money-rails` gem for accurate financial calculations
4. **Country Validation**: Using ISO3166 standard for country codes
5. **Configurable Tax Rates**: Database-driven rates for easy updates without code changes
6. **TDD Approach**: Every feature developed with tests first (RED-GREEN-REFACTOR)

## 📊 Database Schema

### Employees Table
| Column | Type | Description |
|--------|------|-------------|
| id | integer | Primary key |
| first_name | string | Employee name (required) |
| last_name | string | Employee name (required) |
| job_title | string | Job position (required) |
| country_code | string | ISO country code (required) |
| currency_code | string | ISO currency code (auto-set) |
| gross_salary | decimal | Salary before deductions (> 0) |
| net_salary | decimal | Salary after deductions (calculated) |
| tds_percentage | decimal | Tax deducted amount (calculated) |
| deductions | json | Detailed deductions (calculated) |

### Tax Rates Table
| Column | Type | Description |
|--------|------|-------------|
| id | integer | Primary key |
| country_code | string | ISO country code |
| tds_rate | decimal | Tax deduction percentage |
| active | boolean | Rate status |

## 🚦 Error Handling

The API returns appropriate HTTP status codes:

- `200 OK` - Successful GET request
- `201 Created` - Successful POST request
- `204 No Content` - Successful DELETE request
- `400 Bad Request` - Missing required parameters
- `404 Not Found` - Resource not found
- `422 Unprocessable Entity` - Validation errors

Error responses include meaningful messages:
```json
{
  "error": "Validation failed",
  "details": [
    "Full name can't be blank",
    "Gross salary must be greater than 0"
  ]
}
```

## 🔧 API Endpoints

### Employee Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/employees` | List all employees (paginated) |
| GET | `/api/v1/employees/:id` | Get employee details |
| POST | `/api/v1/employees` | Create new employee |
| PUT | `/api/v1/employees/:id` | Update employee |
| DELETE | `/api/v1/employees/:id` | Delete employee |

### Metrics

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/metrics/salaries/by_country?country=IN` | Get salary metrics by country |
| GET | `/api/v1/metrics/salaries/by_job_title?job_title=Backend Developer` | Get average salary by job title |

## 📝 API Usage Examples

### Create Employee
```bash
curl -X POST http://localhost:3000/api/v1/employees \
  -H "Content-Type: application/json" \
  -d '{
    "employee": {
      "full_name": "John Doe",
      "job_title": "Software Engineer",
      "country_code": "IN",
      "gross_salary": 100000
    }
  }'
```

Response:
```json
{
  "id": 1,
  "full_name": "John Doe",
  "job_title": "Software Engineer",
  "country_code": "IN",
  "currency_code": "INR",
  "gross_salary": "100000.0",
  "net_salary": "90000.0"
}
```

### Get Salary Calculation
```bash
curl http://localhost:3000/api/v1/employees/1/salary
```

Response:
```json
{
  "employee_id": 1,
  "employee_name": "John Doe",
  "country": "India",
  "gross_salary": "100000.0",
  "currency": "INR",
  "deductions": {
    "tds": 10000.0,
    "tds_rate": 10.0
  },
  "net_salary": "90000.0"
}
```

### Get Metrics by Country
```bash
curl "http://localhost:3000/api/v1/metrics/salaries/by_country?country=IN"
```

Response:
```json
{
  "country": "IN",
  "currency": "INR",
  "metrics": {
    "min_salary": "50000.0",
    "max_salary": "150000.0",
    "avg_salary": 75000.0,
    "employee_count": 5
  }
}
```

## 💰 Tax Deduction Rules

Current TDS (Tax Deducted at Source) rates:

| Country | TDS Rate |
|---------|----------|
| India (IN) | 10% |
| United States (US) | 12% |
| Other Countries | 0% |

Tax rates are configurable and stored in the database. To modify rates:
```ruby
# Rails console
rails console

# Update existing rate
TaxRate.find_by(country_code: 'IN').update(tds_rate: 15)

# Add new country
TaxRate.create(country_code: 'GB', tds_rate: 20, active: true)
```

## 🧪 Testing

The project follows Test-Driven Development (TDD) with comprehensive test coverage.

### Run all tests:
```bash
bundle exec rspec
```

### Run with coverage report:
```bash
COVERAGE=true bundle exec rspec
```

Coverage report will be generated in `coverage/index.html`

### Run specific tests:
```bash
# Model tests
bundle exec rspec spec/models/

# Controller tests
bundle exec rspec spec/requests/

# Service tests
bundle exec rspec spec/services/
```
###  AI Usage and Implementation Details

This project was built using AI assistance (Claude) to demonstrate modern development practices:

### Where AI was used:
- **Code Scaffolding**: Initial project structure and boilerplate
- **Test Generation**: Comprehensive test cases covering edge cases
- **Documentation**: API documentation and this README
- **Best Practices**: Rails conventions and design patterns

### TDD Workflow:
Every feature was implemented following strict TDD:
1. **RED**: Write failing tests first
2. **GREEN**: Implement minimal code to pass
3. **REFACTOR**: Improve code quality

### Commit History:
The git history demonstrates the TDD cycle with commits clearly marked:
- `test(feature): ... [RED]` - Failing tests
- `feat(feature): ... [GREEN]` - Implementation
- `refactor(feature): ... [REFACTOR]` - Code improvements

## 🔐 Security Considerations

- Strong parameter validation in controllers
- SQL injection prevention through ActiveRecord
- Decimal precision for financial calculations
- Input sanitization and validation
- Proper error messages without sensitive data exposure

## 📈 Performance Optimizations

- Database indexes on frequently queried columns
- Efficient pagination with Pagy gem
- Optimized queries for metrics calculations
- JSON serialization without N+1 queries

## 🔄 Future Improvements

- [ ] Add authentication and authorization
- [ ] Implement caching for metrics endpoints
- [ ] Add bulk import/export functionality
- [ ] Support for multiple deduction types
- [ ] Historical salary tracking
- [ ] GraphQL API alternative
- [ ] Add Docker containerization
- [ ] Implement rate limiting
- [ ] Add API versioning through headers
- [ ] Audit logging for all changes
- [ ] Add API documentation using swagger