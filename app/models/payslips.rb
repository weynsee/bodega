class Payslips
  TYPES = %i(salary_payslips rice_allowance_payslips)

  def self.include?(str)
    TYPES.include?(str.pluralize.to_sym)
  end
end
