module ActsAsAdvanceController
  extend ActiveSupport::Concern
  include PathHelper

  included do
    class_attribute :_base, :association, :singular, :model

    self._base = self.name.gsub('Controller', '')
    self.association = _base.tableize
    self.singular = association.singularize
    self.model = _base.singularize.constantize

    helper_method :edit_advance_path
    helper_method :advance_path
    helper_method :advance_types
    helper_method :advance_name
    helper_method :advance_form_path
  end

  def index
    scope = employee_context? ? employee_advances : model.all
    scope = scope.order(created_at: :desc)
    @pagy, @advances = pagy(scope, page: params[:page], items: 25)

    render "employees/#{association}" if employee_context?
  end

  def new
    @advance = employee_advances.new
  end

  def create
    @advance = employee_advances.new(advance_params)

    if @advance.save
      path = public_send("employee_#{association}_path", @employee)
      redirect_to path, notice: 'Record saved successfully!'
    else
      render partial: 'shared/advances/update_form'
    end
  end

  def edit
    @advance = find_advance
    flash.now[:warning] = included_in_payslip_warning(@advance) if @advance.included_in_payslip?
  end

  def update
    @advance = find_advance

    if @advance.update_attributes(advance_params)
      path = public_send("nesting_aware_#{association}_path")
      redirect_to path, notice: 'Record saved successfully!'
    else
      render partial: 'shared/advances/update_form'
    end

  end

  def show
    @advance = model.find(params[:id])

    render template: 'shared/advances/_receipt'
  end

  def destroy
    advance = find_advance
    path = public_send("nesting_aware_#{association}_path")
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

  def advance_form_path
    @advance.new_record? ?
      public_send("employee_#{association}_path") :
      public_send("nesting_aware_#{singular}_path", @advance)
  end

  def advance_name
    singular.humanize(capitalize: false)
  end

  def edit_advance_path(advance)
    public_send("nesting_aware_edit_#{singular}_path", advance)
  end

  def advance_path(advance, nesting = true)
    if nesting
      public_send("nesting_aware_#{singular}_path", advance)
    else
      public_send("#{singular}_path", advance)
    end
  end

  def advance_types
    model.advance_types
  end

  def print_preview?
    action_name == 'show'
  end

  def included_in_payslip_warning(advance)
    payslip = view_context.link_to 'payslip', payslip_path_for_advance(advance)
    "This advance is included in a #{payslip} and some fields cannot be modified."
  end

  def employee_advances
    employee.public_send(association)
  end

  def find_advance
    employee_context? ? employee_advances.find(params[:id]) : model.find(params[:id])
  end

  def advance_params
    params.require(singular.to_sym).permit(
      :advance_type,
      :amount,
      :applies_on,
      :description,
      :notes
    )
  end
end
