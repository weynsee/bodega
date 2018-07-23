class SalaryAdvancesController < ApplicationController
  include PathHelper

  def index
    scope = employee_context? ? employee.salary_advances : SalaryAdvance.all
    scope = scope.order(created_at: :desc)
    @pagy, @advances = pagy(scope, page: params[:page], items: 25)

    render 'employees/salary_advances' if employee_context?
  end

  def show
    @advance = SalaryAdvance.find(params[:id])
  end

  def new
    @advance = employee.salary_advances.new
  end

  def create
    @advance = employee.salary_advances.new(salary_advance_params)

    if @advance.save
      redirect_to employee_salary_advances_path(@employee), notice: 'Record saved successfully!'
    end
  end

  def edit
    @advance = find_advance
    flash.now[:warning] = included_in_payslip_warning(@advance) if @advance.included_in_payslip?
  end

  def update
    @advance = find_advance

    if @advance.update_attributes(salary_advance_params)
      redirect_to nesting_aware_salary_advances_path,
        notice: 'Record saved successfully!'
    end
  end

  def destroy
    advance = find_advance
    if advance
      if !advance.included_in_payslip?
        advance.destroy
        redirect_to nesting_aware_salary_advances_path,
          notice: 'Record deleted successfully!'
      else
        redirect_to nesting_aware_salary_advances_path,
          alert: included_in_payslip_warning(advance)
      end
    else
      redirect_to nesting_aware_salary_advances_path,
        alert: 'Record does not exist!'
    end
  end

  private

  def print_preview?
    action_name == 'show'
  end

  def included_in_payslip_warning(advance)
    payslip = view_context.link_to 'payslip',
      nesting_aware_salary_payslip_path(advance.salary_payslip)
    "This advance is included in a #{payslip} and some fields cannot be modified."
  end

  def find_advance
    employee_context? ? employee.salary_advances.find(params[:id]) : SalaryAdvance.find(params[:id])
  end

  def salary_advance_params
    params.require(:salary_advance).permit(
      :advance_type,
      :amount,
      :applies_on,
      :description,
      :notes
    )
  end
end
