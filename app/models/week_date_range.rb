class WeekDateRange < DateRange
  class << self
    def format_date(date)
      "#{date.year}-W#{rjust(date.cweek)}"
    end
  end

  def initialize(token)
    @token = token
    parse token
  end

  def next
    @date.next_week
  end

  private

  def parse(token)
    year, week = token.split('-')
    @date = Date.commercial(year.to_i, week.gsub('W', '').to_i)

    @start = @date.beginning_of_week
    @end = @date.end_of_week
  end
end
