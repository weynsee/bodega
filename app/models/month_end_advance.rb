class MonthEndAdvance < ApplicationRecord
  include HasAppliesOn
  include HasPayslip

  enum advance_type: %i(regular carry_over)

  validates :amount, numericality: { greater_than: 0 }
  validates :advance_type, inclusion: { in: MonthEndAdvance.advance_types.keys, message: :invalid }

  belongs_to :employee, optional: true
  belongs_to :month_end_payslip, optional: true

  alias_attribute :payslip, :month_end_payslip

  after_initialize :set_default_applies_on

  def monthly?
    true
  end
end
