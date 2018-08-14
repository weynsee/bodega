module HasAdvanceAppliesOn
  extend ActiveSupport::Concern

  included do
    include HasAppliesOn
    validate :no_payslip_conflict
  end

  private

  def no_payslip_conflict
    if !included_in_payslip? && applies_on.present?
      association = self.class.name.tableize.gsub('advances', 'payslips')
      if employee.public_send(association).where(applies_on: applies_on).present?
        errors.add :applies_on, "Advance can't be created because a payslip for that period has already been created"
      end
    end
  end
end
