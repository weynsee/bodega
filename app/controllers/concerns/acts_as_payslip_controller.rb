module ActsAsPayslipController
  extend ActiveSupport::Concern
  include PathHelper

  included do
    class_attribute :_base, :association, :singular, :model

    self._base = self.name.gsub('Controller', '')
    self.association = _base.tableize
    self.singular = association.singularize
    self.model = _base.singularize.constantize

    helper_method :payslip_path
    helper_method :payslip_form_path
    helper_method :new_payslip_path
    helper_method :edit_advance_path
    helper_method :preview_path
  end

  def index
    scope = employee_context? ? employee_payslips : model.all
    scope = scope.order(created_at: :desc)
    @pagy, @payslips = pagy(scope, page: params[:page], items: 25)

    render "employees/#{association}" if employee_context?
  end

  def create
    @payslip = employee_payslips.new(payslip_params)

    if @payslip.save
      path = public_send("employee_#{association}_path", @employee)
      redirect_to path, notice: payslip_created_message(@payslip)
    end
  end

  def new
    if has_params?
      @payslip = employee_payslips.new(payslip_params)
      valid = @payslip.valid?
      flash.now[:warning] = "This payslip has a negative amount and will generate a carry over advance." if valid && @payslip.total.negative?
    else
      @payslip = employee_payslips.new
    end
  end

  def show
    @payslip = find_payslip
  end

  def destroy
    payslip = find_payslip
    payslip.destroy if payslip
    path = public_send("nesting_aware_#{association}_path")
    redirect_to path, notice: 'Payslip deleted successfully!'
  end

  private

  def edit_advance_path(advance, nesting = false)
    if nesting
      public_send("nesting_aware_edit_#{advance_kind(advance)}_path", advance)
    else
      public_send("edit_employee_#{advance_kind(advance)}_path", @employee, advance)
    end
  end

  def preview_path
    public_send("nesting_aware_#{singular}_path", @payslip, printer: true)
  end

  def payslip_form_path
    public_send("employee_#{association}_path")
  end

  def new_payslip_path
    public_send("new_employee_#{singular}_path", @employee)
  end

  def payslip_path(payslip)
    public_send("nesting_aware_#{singular}_path", payslip)
  end

  def employee_payslips
    employee.public_send(association)
  end

  def find_payslip
    employee_context? ? employee_payslips.find(params[:id]) : model.find(params[:id])
  end

  def payslip_params
    params.require(singular).permit(
      :days_present,
      :applies_on
    )
  end

  def advance_kind(advance)
    advance.class.name.underscore
  end

  def payslip_created_message(payslip)
    message = 'Payslip generated successfully!'
    if payslip.carry_over
      carry_over = payslip.carry_over
      advance_link = view_context.link_to(
        advance_kind(carry_over).humanize(capitalize: false),
        edit_advance_path(carry_over)
      )
      carry_over = " Because the total was negative, it generated a #{advance_link} for the next period."
      message += carry_over
    end
    message
  end

  def has_params?
    params[singular].present?
  end

  def preview_mode?
    params[singular].present? &&
      payslip_params[:days_present].present? &&
      payslip_params[:applies_on].present?
  end
end
