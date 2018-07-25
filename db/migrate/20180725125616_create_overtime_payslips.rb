class CreateOvertimePayslips < ActiveRecord::Migration[5.2]
  def change
    create_table :overtime_payslips do |t|
      t.references :employee, foreign_key: true
      t.string :applies_on, null: false
      t.float :hours, null: false
      t.float :rate, null: false
      t.float :total, null: false

      t.timestamps

      t.index [:employee_id, :applies_on],
        unique: true
    end
  end
end
