class Deductions
  TYPES = %i(salary_advances rice_allowance_advances month_end_advances year_end_advances)

  def self.include?(str)
    TYPES.include?(str.pluralize.to_sym)
  end
end
