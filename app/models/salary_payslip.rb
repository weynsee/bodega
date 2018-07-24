class SalaryPayslip < ApplicationRecord
  include HasInheritableRate
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

  def salary_advances_total
    salary_advances.sum(:amount)
  end

  def applicable_advances
    employee.salary_advances.applies_for(salary_type, applies_on)
  end
end
