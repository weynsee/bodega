module HasIssueDate
  extend ActiveSupport::Concern

  included do
    validates :issue_date, null: false

    after_initialize :set_default_issue_date, if: :new_record?
  end

  private

  def set_default_issue_date
    self.issue_date = Date.today if self.issue_date.blank?
  end
end
