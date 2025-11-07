class EmployeeSerializer
  include JSONAPI::Serializer

  # Always included attributes
  attributes :id, :job_title, :net_salary, :tds_percentage

  attribute :full_name do |object|
    "#{object.first_name} #{object.last_name}"
  end

  attribute :country do |object|
    object.country_name
  end

  attribute :currency do |object|
    object.currency_code
  end

  # Conditional attributes for detail view
  attribute :gross_salary, if: proc { |_, params| params && params[:view] == :detail } do |object|
    object.gross_salary
  end

  attribute :deductions, if: proc { |_, params| params && params[:view] == :detail } do |object|
    object.deductions
  end
end
