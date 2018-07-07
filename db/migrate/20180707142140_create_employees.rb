class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :name, index: true, null: false
      t.float :rate, null: false
      t.integer :rate_type, null: false, default: 0
      t.float :rice_allowance_rate, null: false
      t.float :overtime_rate, null: false
      t.float :month_end_rate, null: false
      t.float :year_end_rate, null: false

      t.timestamps
    end
  end
end
