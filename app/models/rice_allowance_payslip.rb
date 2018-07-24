class RiceAllowancePayslip < ApplicationRecord
  include HasInheritableRate
  include HasAppliesOn
  include HasDeductions
  include DateRangeHelper

  validates :days_present, numericality: {
    greater_than_or_equal_to: 0, less_than: 7
  }
  validates :total, numericality: true
  validates :applies_on, uniqueness: { scope: :employee_id }

  belongs_to :employee, optional: true
  has_many :rice_allowance_advances, dependent: :nullify

  def applicable_advances
    employee.rice_allowance_advances.applies_for(applies_on)
  end

  def weekly?
    true
  end
end
