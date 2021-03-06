class OvertimePayslip < ApplicationRecord
  include HasSearchQuery
  include HasInheritableRate
  include HasAppliesOn
  include HasIssueDate
  include HasAttendances

  validates :hours, numericality: { greater_than_or_equal_to: 0 }
  validates :total, numericality: true
  validates :applies_on, uniqueness: { scope: :employee_id }

  belongs_to :employee, optional: true

  before_validation :compute
  after_initialize :set_default_applies_on, if: :new_record?

  def total_income
    rate * hours
  end

  def total_deductions
    0
  end

  def attendance_type
    :overtime
  end

  def compute
    return if employee.blank?
    return if hours.blank? || applies_on.blank?
    self.total = total_income
  end

  def weekly?
    true
  end

  def applicable_advances
    []
  end

  def attendance
    :hours
  end

  def carry_over
    nil
  end

  def advances
    []
  end
end
