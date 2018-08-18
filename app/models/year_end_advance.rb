class YearEndAdvance < ApplicationRecord
  include HasSearchQuery
  include HasAdvanceAppliesOn
  include HasPayslip
  include HasIssueDate

  enum advance_type: %i(regular carry_over)

  validates :amount, numericality: { greater_than: 0 }
  validates :advance_type, inclusion: { in: YearEndAdvance.advance_types.keys, message: :invalid }

  belongs_to :employee, optional: true
  belongs_to :year_end_payslip, optional: true

  alias_attribute :payslip, :year_end_payslip

  after_initialize :set_default_applies_on, if: :new_record?

  def yearly?
    true
  end
end
