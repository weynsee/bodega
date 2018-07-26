class YearEndAdvance < ApplicationRecord
  include HasAppliesOn
  include HasPayslip

  enum advance_type: %i(regular carry_over)

  validates :amount, numericality: { greater_than: 0 }
  validates :advance_type, inclusion: { in: YearEndAdvance.advance_types.keys, message: :invalid }

  belongs_to :employee, optional: true
  belongs_to :year_end_payslip, optional: true

  alias_attribute :payslip, :year_end_payslip

  after_initialize :set_default_applies_on

  def yearly?
    true
  end
end
