class EmployeesController < ApplicationController
  def index
    scope = params[:name].present? ? Employee.search(params[:name]) : Employee.all
    @pagy, @employees = pagy(scope, page: params[:page], items: 25)
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      redirect_to employees_path, notice: 'Record saved successfully!'
    end
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])

    if @employee.update_attributes(employee_params)
      redirect_to employees_path, notice: 'Record saved successfully!'
    end
  end

  def destroy
    employee = Employee.find(params[:id])
    employee.destroy if employee
    redirect_to employees_path, notice: 'Record deleted successfully!'
  end

  private

  def employee_params
    params.require(:employee).permit(
      :name,
      :rate_type,
      :rate,
      :overtime_rate,
      :rice_allowance_rate,
      :month_end_rate,
      :year_end_rate,
      :status
    )
  end
end
