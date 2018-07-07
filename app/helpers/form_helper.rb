module FormHelper
  CURRENCY_SYMBOL = I18n.t('number.currency.format.unit')

  def rate_field_value(val, opts = {})
    return {
      step: 'any',
      min: 1,
      value: number_with_precision(val, precision: 2),
      prepend: CURRENCY_SYMBOL
    }.merge(opts)
  end

  def half_month_options(date_range)
    relative = date_range.start
    iter = relative - 1.month
    last = relative + 6.months
    options = []
    loop do
      a, b = HalfMonthDateRange.format_date(iter.beginning_of_month),
        HalfMonthDateRange.format_date(iter.end_of_month)
      range_a, range_b = HalfMonthDateRange.new(a), HalfMonthDateRange.new(b)
      options << [display_date_range(range_a), a]
      options << [display_date_range(range_b), b]
      break if iter == last
      iter = iter.next_month
    end
    options
  end
end
