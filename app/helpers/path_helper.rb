module PathHelper
  [Deductions::TYPES + Payslips::TYPES].flatten.each do |type|
    define_method :"nesting_aware_#{type}_path" do
      employee_context? ? public_send("employee_#{type}_path", @employee) :
        public_send("#{type}_path")
    end

    define_method :"nesting_aware_#{type.to_s.singularize}_path" do |advance, options = {}|
      singular = type.to_s.singularize
      employee_context? ? public_send("employee_#{singular}_path", @employee, advance, options) :
        public_send("#{singular}_path", advance, options)
    end

    define_method :"nesting_aware_edit_#{type.to_s.singularize}_path" do |advance|
      singular = type.to_s.singularize
      employee_context? ? public_send("edit_employee_#{singular}_path", @employee, advance) :
        public_send("edit_#{singular}_path", advance)
    end
  end

  def payslip_path_for_advance(advance)
    payslip_path = advance.payslip.class.name.tableize.singularize
    public_send("nesting_aware_#{payslip_path}_path", advance.payslip)
  end
end
