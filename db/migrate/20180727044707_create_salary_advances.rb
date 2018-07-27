class CreateSalaryAdvances < ActiveRecord::Migration[5.2]
  def change
    create_table :salary_advances do |t|
      t.references :employee, foreign_key: true
      t.integer :advance_type, null: false, default: 0
      t.integer :salary_type, null: false
      t.float :amount, null: false
      t.string :applies_on, null: false
      t.references :salary_payslip, foreign_key: true
      t.string :description
      t.string :notes

      t.timestamps

      t.index [:employee_id, :salary_type, :applies_on], name: :index_salary_advances_on_employee_id_and_salary_type_and_date
    end
  end
end
