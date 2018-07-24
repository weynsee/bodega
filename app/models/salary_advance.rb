class SalaryAdvance < ApplicationRecord
  include HasSalaryType
  include HasAppliesOn
  include HasPayslip

  enum advance_type: %i(regular carry_over utilities)

  validates :amount, numericality: { greater_than: 0 }
  validates :advance_type, inclusion: { in: SalaryAdvance.advance_types.keys, message: :invalid }

  belongs_to :employee, optional: true
  belongs_to :salary_payslip, optional: true

  alias_attribute :payslip, :salary_payslip
end
