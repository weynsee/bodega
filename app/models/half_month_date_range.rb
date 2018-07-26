class HalfMonthDateRange < DateRange
  class << self
    def format_date(date)
      prefix = "#{date.year}-#{rjust(date.month)}:"
      prefix + (date.day <= 15 ? 'a' : 'b')
    end
  end

  attr_reader :start, :end

  def initialize(token)
    parse token
  end

  def next
    @date + 16.days
  end

  private

  def parse(token)
    date, half = token.split(':')
    year, month = date.split('-')
    @date = Date.new(year.to_i, month.to_i, half == 'a' ? 1 : 16)

    @start = @date.beginning_of_month
    @end = @date.end_of_month
    @start = Date.new(@date.year, @date.month, 16) if @date.day > 15
    @end = Date.new(@date.year, @date.month, 15) if @date.day < 16
  end
end
