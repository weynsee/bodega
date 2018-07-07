module HasPayslip
  extend ActiveSupport::Concern

  included do
    validates :payslip_id, absence: true, unless: :new_record?

    before_destroy :check_if_included_in_payslip
  end

  def included_in_payslip?
    payslip_id.present?
  end

  private

  def check_if_included_in_payslip
    if included_in_payslip?
      errors.add :base, "you can't delete an advance if it's included in a payslip"
      throw(:abort)
    end
  end
end
