class RiceAllowancePayslip < ApplicationRecord
  include HasSearchQuery
  include HasInheritableRate
  include HasAppliesOn
  include HasDeductions
  include HasIssueDate

  validates :days_present, numericality: {
    greater_than_or_equal_to: 0, less_than: 7
  }
  validates :total, numericality: true
  validates :applies_on, uniqueness: { scope: :employee_id }

  belongs_to :employee, optional: true
  has_many :rice_allowance_advances, dependent: :nullify

  after_initialize :set_default_applies_on, if: :new_record?

  alias_attribute :advances, :rice_allowance_advances

  def applicable_advances
    employee.rice_allowance_advances.applies_for(applies_on)
  end

  def weekly?
    true
  end

  def attendance
    :days_present
  end
end
