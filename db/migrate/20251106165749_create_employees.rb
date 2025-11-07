class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :job_title, null: false
      t.string :country_code, null: false
      t.string :currency_code
      t.decimal :gross_salary, precision: 12, scale: 2, null: false
      t.decimal :net_salary, precision: 12, scale: 2
      t.integer :tds_percentage, default: 0
      t.decimal :deductions, precision: 12, scale: 2, default: 0
      
      t.timestamps
    end

    add_index :employees, :country_code
    add_index :employees, :job_title
  end
end
