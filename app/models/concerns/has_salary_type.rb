module HasSalaryType
  extend ActiveSupport::Concern

  included do
    enum salary_type: SalaryTypes.keys

    validates :salary_type, inclusion: { in: SalaryTypes.keys, message: :invalid }
  end

  private

  def set_salary_type
    self.salary_type = employee.rate_type if self.employee_id
  end
end
