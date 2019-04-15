class Attendance < ApplicationRecord
  enum attendance_type: %i(regular overtime)

  belongs_to :employee

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :applies_on, uniqueness: { scope: [:employee_id, :attendance_type] }, presence: true

  def self.find_record(name, params)
    employee = Employee.name_like(name).first
    if employee
      attendance = Attendance.find_or_initialize_by(
        employee: employee,
        applies_on: params[:applies_on],
        attendance_type: params[:attendance_type]
      )
      attendance.assign_attributes(params)
      attendance
    end
  end
end
