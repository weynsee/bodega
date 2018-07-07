module DateRangeHelper
  def format_date_range(date_range)
    "#{format_date(date_range.start)} to #{format_date(date_range.end)}"
  end

  def format_date(date)
    date.strftime('%b %d')
  end

  def display_date_range(date_range)
    "#{date_range} (#{format_date_range(date_range)})"
  end
end
