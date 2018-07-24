module HasDeductions
  extend ActiveSupport::Concern

  included do
    before_validation :compute

    after_create :assign_advances
    after_create :create_carry_over

    attr_reader :carry_over
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

  private

  def assign_advances
    attr_name = "#{self.class.name.underscore}_id"
    applicable_advances.update_all(attr_name => id)
  end

  def create_carry_over
    if total.negative?
      association = self.class.name.tableize.gsub('payslips', 'advances')
      advance = employee.public_send(association).new
      advance.applies_on = date_range_class.format_date date_range.next
      advance.advance_type = :carry_over
      advance.amount = total.abs
      advance.description = "Carry over from negative balance (payslip #{format_date_range(date_range)})"
      advance.save
      @carry_over = advance
    end
  end
end
