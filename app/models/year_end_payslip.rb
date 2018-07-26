class YearEndPayslip < ApplicationRecord
  include HasInheritableRate
  include HasAppliesOn
  include HasDeductions

  validates :days_present, numericality: {
    greater_than_or_equal_to: 0, less_than: 367
  }
  validates :total, numericality: true
  validates :applies_on, uniqueness: { scope: :employee_id }

  belongs_to :employee, optional: true
  has_many :year_end_advances, dependent: :nullify

  after_initialize :set_default_applies_on

  alias_attribute :advances, :year_end_advances

  def applicable_advances
    employee.year_end_advances.applies_for(applies_on)
  end

  def total_income
    base_rate * days_present
  end

  def base_rate
    rate.fdiv 365
  end

  def yearly?
    true
  end

  def attendance
    :days_present
  end
end
