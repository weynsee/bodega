module PayslipsHelper
  def advance_billing_item_label(advance)
    description = "(#{advance.description})" if advance.description.present?
    <<-ITEM
    #{advance.advance_type.humanize} salary advance
    on
    #{advance.issue_date.strftime('%m/%d')}
    #{description}
    ITEM
  end

  def each_advance_billing_item(advances)
    rest = []
    advances.each_with_index do |advance, index|
      if index < 5
        yield advance
      else
        rest << advance
      end
    end
    yield rest if rest.present?
  end

  def format_attendance(payslip)
    "#{number_with_precision(payslip.send(payslip.attendance), precision: 2)} #{payslip.attendance.to_s.humanize(capitalize: false)}"
  end
end
