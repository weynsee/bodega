class Deductions
  TYPES = %i(salary_advances rice_allowance_advances)

  def self.include?(str)
    TYPES.include?(str.pluralize.to_sym)
  end
end
