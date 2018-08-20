module PayslipsHelper
  def advance_billing_item_label(advance)
    description = "- #{advance.description}" if advance.description.present?
    <<-ITEM
    #{advance.issue_date.strftime('%m/%d')}
    #{description}
    ITEM
  end

  def format_attendance(payslip)
    "#{number_with_precision(payslip.send(payslip.attendance), precision: 2)} #{payslip.attendance.to_s.humanize(capitalize: false)}"
  end
end
