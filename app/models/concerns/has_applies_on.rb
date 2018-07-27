module HasAppliesOn
  extend ActiveSupport::Concern

  included do
    validates :applies_on, presence: true
  end

  def date_range
    @date_range ||= date_range_class.new(applies_on)
  end

  def weekly?
    false
  end

  def half_monthly?
    false
  end

  def yearly?
    false
  end

  def monthly?
    false
  end

  private

  def date_range_class
    return WeekDateRange if weekly?
    return HalfMonthDateRange if half_monthly?
    return MonthDateRange if monthly?
    return YearDateRange if yearly?
  end

  def set_default_applies_on
    self.applies_on = date_range_class.format_date(Date.today)
  end
end
