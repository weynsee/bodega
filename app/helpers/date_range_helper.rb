module DateRangeHelper
  def parse_date_range_token(token, type)
    date_range_class_for(type).new(token)
  end

  private

  def date_range_class_for(type)
    return WeekDateRange if type == 'weekly'
    return HalfMonthDateRange if type == 'half_monthly'
    return MonthDateRange if type == 'monthly'
    return YearDateRange if type == 'yearly'
  end
end
