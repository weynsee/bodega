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
  has_many :attendances, dependent: :destroy do
    def for(type, start_date, end_date)
      clause = where(attendance_type: type)
      clause = clause.where('applies_on >= ?', start_date) if start_date.present?
      clause = clause.where('applies_on <= ?', end_date) if end_date.present?
      clause = clause.order(applies_on: :desc)
      clause
    end
  end

  scope :name_like, ->(name) { where('name ILIKE ?', "%#{name}%") }

  def self.search(name: nil, rate_type: nil)
    scope = where(nil)
    scope = scope.merge(Employee.name_like(name)) if name.present?
    scope = scope.where(rate_type: rate_type) if rate_type.present?
    scope
  end

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
