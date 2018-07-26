class DateRange
  attr_reader :start, :end

  def self.rjust(token)
    token.to_s.rjust(2, '0')
  end

  def to_s
    format_date_range
  end

  private

  def format_date_range
    "#{date_format(@start)} to #{date_format(@end)}"
  end

  def date_format(date)
    date.strftime('%b %d')
  end
end
