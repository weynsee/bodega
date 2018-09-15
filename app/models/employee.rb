class Employee < ApplicationRecord
  enum rate_type: SalaryTypes.keys
  enum status: %i(active inactive)

  validates :name, presence: true
  validates :rate, numericality: { greater_than: 0 }
  validates :overtime_rate, numericality: { greater_than: 0 }
  validates :rice_allowance_rate, numericality: { greater_than: 0 }
  validates :month_end_rate, numericality: { allow_nil: true }
  validates :year_end_rate, numericality: { allow_nil: true }
  validates :rate_type, inclusion: { in: rate_types.keys, message: :invalid }

  after_validation :set_cash_bond

  scope :search, ->(name) { where("name ILIKE ?", "%#{name}%") }

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

  def has_month_end?
    month_end_rate.present? && !month_end_rate.zero?
  end

  def has_year_end?
    year_end_rate.present? && !year_end_rate.zero?
  end

  def disallowed?(type)
    type = type.to_s.gsub(/_(payslips|advances)$/, '')
    !public_send("has_#{type}?") if respond_to?("has_#{type}?")
  end

  private

  def set_cash_bond
    self.cash_bond = false if !half_monthly?
  end
end
