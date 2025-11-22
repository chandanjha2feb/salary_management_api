source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.2"  # or your Ruby version

gem "rails", "~> 8.1.1"
gem "sqlite3", ">= 2.1"
gem "puma", "~> 6.0"
gem "bootsnap", ">= 1.4.4", require: false
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "rack-cors"
gem "jsonapi-serializer" # API & Serialization
gem "countries", "~> 5.7" # Country & Money handling
gem "pagy", "~> 6.2" # Pagination

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails"
  gem "shoulda-matchers", "~> 5.0"
  gem "faker"
  gem "database_cleaner-active_record"
  gem "simplecov", require: false
end

group :development do
  gem "spring"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

# API Documentation
gem "rswag-api"
gem "rswag-ui"