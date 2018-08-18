AppliesOn = Struct.new(:type, :applies_on, :range) do
  def weekly?
    type.to_s == 'weekly'
  end

  def half_monthly?
    type.to_s == 'half_monthly'
  end

  def monthly?
    type.to_s == 'monthly'
  end

  def yearly?
    type.to_s == 'yearly'
  end

  def date_range
    @date_range ||= date_range_class.new(applies_on_string)
  end

  def applies_on_string
    if applies_on.present? && range.blank?
      applies_on
    elsif range.present? && applies_on.present? && range == type
      applies_on
    else
      date_range_class.format_date(Date.today)
    end
  end

  def date_range_class
    return WeekDateRange if weekly?
    return HalfMonthDateRange if half_monthly?
    return MonthDateRange if monthly?
    return YearDateRange if yearly?
  end
end
