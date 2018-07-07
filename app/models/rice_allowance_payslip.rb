class RiceAllowancePayslip < ApplicationRecord
  validates :rate, numericality: { greater_than: 0 }
  validates :days_present, numericality: {
    greater_than_or_equal_to: 0, less_than: 7
  }
  validates :total, numericality: true

  belongs_to :employee, optional: true
  has_many :rice_allowance_advances, dependent: :nullify

  after_initialize :inherit_rate

  def applicable_advances
    employee.rice_allowance_advances.applies_for(applies_on)
  end

  private

  def inherit_rate
    self.rate = employee.rice_allowance_rate if self.rate.nil? && self.employee_id
  end
end
