module EmployeesHelper
  def info_pill?
    controller_name == 'employees'
  end

  def deductions_pill?
    employee_tab? && Deductions.include?(controller_name)
  end

  def payslips_pill?
    employee_tab? && Payslips.include?(controller_name)
  end

  def attendances_pill?
    employee_tab? && controller_name === 'attendances'
  end
end
