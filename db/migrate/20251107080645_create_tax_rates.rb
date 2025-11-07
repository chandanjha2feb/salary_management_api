class CreateTaxRates < ActiveRecord::Migration[8.1]
  def change
    create_table :tax_rates do |t|
      t.string :country_code, null: false
      t.decimal :tds_rate, precision: 5, scale: 2, null: false
      t.boolean :active, default: true
      t.date :effective_from
      t.date :effective_to
      
      t.timestamps
    end

    add_index :tax_rates, [:country_code, :active]
  end
end
