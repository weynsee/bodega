class SalaryPayslipsController < ApplicationController
  include PathHelper

  def index
    scope = employee_context? ? employee.salary_payslips : SalaryPayslip.all
    scope = scope.order(created_at: :desc)
    @pagy, @payslips = pagy(scope, page: params[:page], items: 25)

    render 'employees/salary_payslips' if employee_context?
  end

  def create
    @payslip = employee.salary_payslips.new(salary_payslip_params)

    if @payslip.save
      redirect_to employee_salary_payslips_path(@employee), notice: payslip_created_message(@payslip)
    end
  end

  def new
    if has_params?
      @payslip = employee.salary_payslips.new(salary_payslip_params)
      valid = @payslip.valid?
      flash.now[:warning] = "This payslip has a negative amount and will generate a carry over advance." if valid && @payslip.total.negative?
    else
      @payslip = employee.salary_payslips.new
    end
  end

  def show
    @payslip = find_payslip
  end

  def destroy
    payslip = find_payslip
    payslip.destroy if payslip
    redirect_to nesting_aware_salary_payslips_path,
      notice: 'Payslip deleted successfully!'
  end

  private

  def find_payslip
    employee_context? ? employee.salary_payslips.find(params[:id]) : SalaryPayslip.find(params[:id])
  end

  def salary_payslip_params
    params.require(:salary_payslip).permit(
      :days_present,
      :applies_on
    )
  end

  def payslip_created_message(payslip)
    message = 'Payslip generated successfully!'
    if payslip.carry_over
      advance_link = view_context.link_to(
        'salary advance',
        edit_employee_salary_advance_path(payslip.employee, payslip.carry_over)
      )
      carry_over = " Because the total was negative, it generated a #{advance_link} for the next period."
      message += carry_over
    end
    message
  end

  def has_params?
    params[:salary_payslip].present?
  end

  def preview_mode?
    params[:salary_payslip].present? &&
      salary_payslip_params[:days_present].present? &&
      salary_payslip_params[:applies_on].present?
  end
end
