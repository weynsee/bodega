module HasPayslip
  extend ActiveSupport::Concern

  included do
    validate :in_payslip_and_cannot_be_modified, on: :update

    before_destroy :check_if_included_in_payslip
  end

  def included_in_payslip?
    payslip.present?
  end

  private

  def in_payslip_and_cannot_be_modified
    if included_in_payslip?
      if amount_changed? || applies_on_changed?
        errors.add :base, "you can't modify an advance if it's included in a payslip"
      end
    end
  end

  def check_if_included_in_payslip
    if included_in_payslip?
      errors.add :base, "you can't delete an advance if it's included in a payslip"
      throw(:abort)
    end
  end
end
