class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.references :employee, foreign_key: true
      t.integer :attendance_type, null: false, default: 0
      t.float :amount, null: false
      t.date :applies_on, null: false

      t.timestamps

      t.index [:employee_id, :applies_on, :attendance_type],
        unique: true,
        name: :index_attendance_on_employee_type_and_date
    end
  end
end
