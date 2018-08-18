module HasSearchQuery
  extend ActiveSupport::Concern

  included do
    def self.search(issue_date: nil, applies_on: nil, included_in_payslip: nil)
      scope = where(nil)
      scope = scope.where(issue_date: issue_date) if issue_date.present?
      scope = scope.where(applies_on: applies_on) if applies_on.present?
      scope = scope.where(payslip_column_name => true) if included_in_payslip.present?
      scope
    end

    def self.payslip_column_name
      column_names.grep(/payslip/).first
    end
  end
end
