module PayslipsHelper
  def advance_billing_item_label(advance)
    description = "- #{advance.description}" if advance.description.present?
    <<-ITEM
    #{advance.issue_date.strftime('%m/%d')}
    #{description}
    ITEM
  end

  def advance_billing_item_group(type, advances)
    text = pluralize(advances.size, "#{type.humanize(capitalize: false)} advance")
    if print_preview?
      mini_breakdown = advances.map { |advance| "<span class=\"text-nowrap\">#{advance.issue_date.strftime('%m/%d')} - #{number_with_precision(advance.amount, precision: 2)}</span>" }.join(', ')
      text += " <small>(#{mini_breakdown})</small>"
    end
    text
  end

  def format_attendance(payslip)
    "#{number_with_precision(payslip.send(payslip.attendance), precision: 2)} #{payslip.attendance.to_s.humanize(capitalize: false)}"
  end

  def applies_on_type(payslip)
    case
    when payslip.weekly?
      'weekly'
    when payslip.half_monthly?
      'half_monthly'
    when payslip.monthly?
      'monthly'
    when payslip.yearly?
      'yearly'
    end
  end
end
