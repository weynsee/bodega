class Payslips
  TYPES = %i(salary_payslips rice_allowance_payslips overtime_payslips
             month_end_payslips year_end_payslips)

  def self.include?(str)
    TYPES.include?(str.pluralize.to_sym)
  end
end
