class MonthDateRange < DateRange
  class << self
    def format_date(date)
      "#{date.year}-#{rjust(date.month)}"
    end
  end

  def initialize(token)
    @token = token
    parse token
  end

  def to_s
    @token
  end

  def next
    @date.next_month
  end

  private

  def parse(date)
    year, month = date.split('-')
    @date = Date.new(year.to_i, month.to_i, 1)

    @start = @date.beginning_of_month
    @end = @date.end_of_month
  end
end
