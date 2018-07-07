module HasSalaryType
  extend ActiveSupport::Concern

  included do
    enum salary_type: SalaryTypes.keys

    validates :salary_type, inclusion: { in: SalaryTypes.keys, message: :invalid }

    after_initialize :set_salary_type
  end

  private

  def set_salary_type
    self.salary_type = employee.rate_type if self.salary_type.blank? && self.employee_id
  end
end
