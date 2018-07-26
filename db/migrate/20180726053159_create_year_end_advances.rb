class CreateYearEndAdvances < ActiveRecord::Migration[5.2]
  def change
    create_table :year_end_advances do |t|
      t.references :employee, foreign_key: true
      t.integer :advance_type, null: false, default: 0
      t.float :amount, null: false
      t.string :applies_on, null: false
      t.references :year_end_payslip, foreign_key: true
      t.string :description
      t.string :notes

      t.timestamps

      t.index [:employee_id, :applies_on]
    end
  end
end
