class WeekDateRange
  class << self
    def format_date(date)
      "#{date.year}-W#{date.cweek.to_s.rjust(2, '0')}"
    end
  end

  attr_reader :start, :end

  def initialize(token)
    @token = token
    parse token
  end

  def to_s
    @token
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
