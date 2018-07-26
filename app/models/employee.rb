class Employee < ApplicationRecord
  enum rate_type: SalaryTypes.keys

  validates :name, presence: true
  validates :rate, numericality: { greater_than: 0 }
  validates :overtime_rate, numericality: { greater_than: 0 }
  validates :rice_allowance_rate, numericality: { greater_than: 0 }
  validates :month_end_rate, numericality: { greater_than: 0 }
  validates :year_end_rate, numericality: { greater_than: 0 }
  validates :rate_type, inclusion: { in: rate_types.keys, message: :invalid }

  scope :search, ->(name) { where('name LIKE ?', name) }

  has_many :salary_advances, dependent: :nullify do
    def applies_for(type, period)
      where(salary_advances: { salary_type: type, applies_on: period })
    end
  end
  has_many :salary_payslips, dependent: :nullify

  has_many :rice_allowance_advances, dependent: :nullify do
    def applies_for(period)
      where(rice_allowance_advances: { applies_on: period })
    end
  end
  has_many :rice_allowance_payslips, dependent: :nullify

  has_many :overtime_payslips, dependent: :nullify

  has_many :month_end_advances, dependent: :nullify do
    def applies_for(period)
      where(month_end_advances: { applies_on: period })
    end
  end
  has_many :month_end_payslips, dependent: :nullify

  has_many :year_end_advances, dependent: :nullify do
    def applies_for(period)
      where(year_end_advances: { applies_on: period })
    end
  end
  has_many :year_end_payslips, dependent: :nullify
end
