class AttendancesController < ApplicationController
  skip_forgery_protection

  def create
    if params[:name].present?
      attendance = Attendance.find_record(
        params[:name],
        attendance_params
      )
      if attendance
        attendance.save!
        head :ok and return
      end
    end

    head :not_found
  end

  private

  def attendance_params
    params.require(:attendance).permit(
      :attendance_type,
      :amount,
      :applies_on
    )
  end
end
