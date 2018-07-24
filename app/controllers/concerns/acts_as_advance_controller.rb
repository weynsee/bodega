module ActsAsAdvanceController
  extend ActiveSupport::Concern
  include PathHelper

  included do
    NAME = self.name.gsub('Controller', '')

    ASSOCIATION = NAME.tableize

    SINGULAR = ASSOCIATION.singularize

    MODEL = NAME.singularize.constantize

    helper_method :edit_advance_path
    helper_method :advance_path
    helper_method :advance_types
  end

  def index
    scope = employee_context? ? employee.public_send(ASSOCIATION) : MODEL.all
    scope = scope.order(created_at: :desc)
    @pagy, @advances = pagy(scope, page: params[:page], items: 25)

    render "employees/#{ASSOCIATION}" if employee_context?
  end

  def new
    @advance = association.new
  end

  def create
    @advance = employee.public_send(ASSOCIATION).new(advance_params)

    if @advance.save
      path = public_send("employee_#{ASSOCIATION}_path", @employee)
      redirect_to path, notice: 'Record saved successfully!'
    end
  end

  def edit
    @advance = find_advance
    flash.now[:warning] = included_in_payslip_warning(@advance) if @advance.included_in_payslip?
  end

  def update
    @advance = find_advance

    if @advance.update_attributes(advance_params)
      path = public_send("nesting_aware_#{ASSOCIATION}_path")
      redirect_to path, notice: 'Record saved successfully!'
    end
  end

  def show
    @advance = MODEL.find(params[:id])
  end

  def destroy
    advance = find_advance
    path = public_send("nesting_aware_#{ASSOCIATION}_path")
    if advance
      if !advance.included_in_payslip?
        advance.destroy
        redirect_to path, notice: 'Record deleted successfully!'
      else
        redirect_to path, alert: included_in_payslip_warning(advance)
      end
    else
      redirect_to path, alert: 'Record does not exist!'
    end
  end

  private

  def edit_advance_path(advance)
    public_send("nesting_aware_edit_#{SINGULAR}_path", advance)
  end

  def advance_path(advance, nesting = true)
    if nesting
      public_send("nesting_aware_#{SINGULAR}_path", advance)
    else
      public_send("#{SINGULAR}_path", advance)
    end
  end

  def advance_types
    MODEL.advance_types
  end

  def print_preview?
    action_name == 'show'
  end

  def included_in_payslip_warning(advance)
    payslip = view_context.link_to 'payslip', payslip_path_for_advance(advance)
    "This advance is included in a #{payslip} and some fields cannot be modified."
  end

  def association
    employee.public_send(ASSOCIATION)
  end

  def find_advance
    employee_context? ? association.find(params[:id]) : MODEL.find(params[:id])
  end

  def advance_params
    params.require(SINGULAR.to_sym).permit(
      :advance_type,
      :amount,
      :applies_on,
      :description,
      :notes
    )
  end
end
