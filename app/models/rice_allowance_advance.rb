class RiceAllowanceAdvance < ApplicationRecord
  include HasAppliesOn
  include HasPayslip

  enum advance_type: %i(regular carry_over)

  validates :amount, numericality: { greater_than: 0 }
  validates :advance_type, inclusion: { in: RiceAllowanceAdvance.advance_types.keys, message: :invalid }

  belongs_to :employee, optional: true
  belongs_to :rice_allowance_payslip, optional: true

  alias_attribute :payslip, :rice_allowance_payslip

  after_initialize :set_default_applies_on

  def weekly?
    true
  end
end
