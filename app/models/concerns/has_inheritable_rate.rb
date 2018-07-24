module HasInheritableRate
  extend ActiveSupport::Concern

  included do
    validates :rate, numericality: { greater_than: 0 }

    after_initialize :inherit_rate
  end

  private

  def inherit_rate
    name = self.class.name.tableize.gsub('_payslips', '')
    name = name == 'salary' ? 'rate' : "#{name}_rate"
    self.rate = employee.public_send(name) if self.rate.nil? && self.employee_id
  end
end
