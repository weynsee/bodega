module HasAttendances
  extend ActiveSupport::Concern

  def attendances
    employee.attendances.for(attendance_type, date_range.start, date_range.end)
  end

  def attendance_type
    :regular
  end
end
