class SalaryPayslip < ApplicationRecord
  include HasSearchQuery
  include HasInheritableRate
  include HasAppliesOn
  include HasSalaryType
  include HasDeductions
  include HasIssueDate
  include HasAttendances

  validates :days_present, numericality: { greater_than_or_equal_to: 0 }
  validates :days_present, numericality: { less_than: 15 }, if: :half_monthly?
  validates :days_present, numericality: { less_than: 7 }, if: :weekly?
  validates :total, numericality: true
  validates :applies_on, uniqueness: { scope: :employee_id }

  belongs_to :employee, optional: true
  has_many :salary_advances, dependent: :nullify

  after_initialize :set_salary_type, if: :new_record?
  after_initialize :set_cash_bond, if: :new_record?
  after_initialize :set_default_applies_on, if: :new_record?

  alias_attribute :advances, :salary_advances

  def applicable_advances
    employee.salary_advances.applies_for(salary_type, applies_on)
  end

  def attendance
    :days_present
  end

  def total_deductions
    total = applicable_advances.sum(:amount)
    total += 100 if cash_bond?
    total
  end

  def total_deducted_amount
    total = advances.sum(:amount)
    total += 100 if cash_bond?
    total
  end

  private

  def set_cash_bond
    self.cash_bond = employee.cash_bond
  end
end
