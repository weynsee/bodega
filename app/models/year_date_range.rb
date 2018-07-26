class YearDateRange < DateRange
  class << self
    def format_date(date)
      date.year.to_s
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
    @date.next_year
  end

  private

  def parse(token)
    @date = Date.new(token.to_i, 1, 1)

    @start = @date.beginning_of_year
    @end = @date.end_of_year
  end
end
