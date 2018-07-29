class MonthEndPayslip < ApplicationRecord
  include HasInheritableRate
  include HasAppliesOn
  include HasDeductions
  include HasIssueDate

  validates :days_present, numericality: {
    greater_than_or_equal_to: 0, less_than: 32
  }
  validates :total, numericality: true
  validates :applies_on, uniqueness: { scope: :employee_id }

  belongs_to :employee, optional: true
  has_many :month_end_advances, dependent: :nullify

  after_initialize :set_default_applies_on, if: :new_record?

  alias_attribute :advances, :month_end_advances

  def applicable_advances
    employee.month_end_advances.applies_for(applies_on)
  end

  def total_income
    base_rate * days_present
  end

  def base_rate
    rate.fdiv 30
  end

  def monthly?
    true
  end

  def attendance
    :days_present
  end
end
