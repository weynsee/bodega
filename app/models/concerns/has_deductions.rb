module HasDeductions
  extend ActiveSupport::Concern

  included do
    before_validation :compute
  end

  def total_deductions
    applicable_advances.sum(:amount)
  end

  def total_income
    rate * days_present
  end

  def compute
    return if employee.blank?
    return if days_present.blank? || applies_on.blank?
    self.total = total_income - total_deductions
  end
end
