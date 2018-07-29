class AddIssueDateToTables < ActiveRecord::Migration[5.2]
  def change
    %i(rice_allowance_advances month_end_advances year_end_advances
       salary_advances overtime_payslips rice_allowance_payslips
       month_end_payslips year_end_payslips salary_payslips).each do |table|
      add_column table, :issue_date, :date

      table.to_s.classify.constantize.update_all("issue_date = created_at")
      change_column_null table, :issue_date, false
    end
  end
end
