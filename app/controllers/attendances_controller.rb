class AttendancesController < ApplicationController
  include DateRangeHelper

  skip_forgery_protection only: :create
  before_action :parse_date_range, only: :index

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

  def index
    @employee = Employee.find(params[:employee_id])
    @attendances = @employee.attendances.for(params[:attendance_type], params[:start_date], params[:end_date]).order(applies_on: :desc)

    respond_to do |format|
      format.html {
        @pagy, @attendances = pagy(@attendances, page: params[:page], items: 25)
        render 'employees/attendances'
      }
      format.js {
        render 'employees/attendances'
      }
    end
  end

  private

  def parse_date_range
    if params[:applies_on].present? && params[:applies_on_type].present?
      date_range = parse_date_range_token(params[:applies_on], params[:applies_on_type])
      params[:start_date] = date_range.start
      params[:end_date] = date_range.end
    end
  end

  def attendance_params
    params.require(:attendance).permit(
      :attendance_type,
      :amount,
      :applies_on
    )
  end
end
