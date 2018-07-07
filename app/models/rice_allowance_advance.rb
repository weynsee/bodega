class RiceAllowanceAdvance < ApplicationRecord
  include HasPayslip

  enum advance_type: %i(regular carry_over)

  validates :amount, numericality: { greater_than: 0 }
  validates :advance_type, inclusion: { in: RiceAllowanceAdvance.advance_types.keys, message: :invalid }

  belongs_to :employee, optional: true
  belongs_to :rice_allowance_payslip, optional: true

  alias_attribute :payslip_id, :rice_allowance_payslip_id
end
