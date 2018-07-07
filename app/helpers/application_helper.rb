module ApplicationHelper
  include Pagy::Frontend

  def employee_tab?
    controller_name == 'employees' || employee_context?
  end

  def deductions_tab?
    !employee_context? && Deductions.include?(controller_name)
  end

  def payslips_tab?
    !employee_context? && Payslips.include?(controller_name)
  end

  def flash_type(type)
    case type
    when 'notice'
      :success
    when 'error', 'alert'
      :danger
    else
      type
    end
  end
end
