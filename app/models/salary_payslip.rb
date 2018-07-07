class SalaryPayslip < ApplicationRecord
  include HasSalaryType
  include HasAppliesOn
  include DateRangeHelper
  include HasDeductions

  validates :rate, numericality: { greater_than: 0 }
  validates :days_present, numericality: { greater_than_or_equal_to: 0 }
  validates :days_present, numericality: { less_than: 15 }, if: :half_monthly?
  validates :days_present, numericality: { less_than: 7 }, if: :weekly?
  validates :total, numericality: true
  validates :applies_on, uniqueness: { scope: :employee_id }

  belongs_to :employee, optional: true
  has_many :salary_advances, dependent: :nullify

  after_initialize :inherit_rate
  before_validation :compute
  after_create :assign_advances
  after_create :create_carry_over

  attr_reader :carry_over

  def salary_advances_total
    salary_advances.sum(:amount)
  end

  def applicable_advances
    employee.salary_advances.applies_for(salary_type, applies_on)
  end

  private

  def inherit_rate
    self.rate = employee.rate if self.rate.nil? && self.employee_id
  end

  def assign_advances
    applicable_advances.update_all(salary_payslip_id: id)
  end

  def create_carry_over
    if total.negative?
      advance = employee.salary_advances.new
      advance.applies_on = date_range_class.format_date date_range.next
      advance.advance_type = :carry_over
      advance.amount = total.abs
      advance.description = "Carry over from negative balance (salary payslip #{format_date_range(date_range)})"
      advance.save
      @carry_over = advance
    end
  end
end
