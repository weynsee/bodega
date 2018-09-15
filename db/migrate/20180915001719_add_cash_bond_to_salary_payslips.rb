class AddCashBondToSalaryPayslips < ActiveRecord::Migration[5.2]
  def change
    add_column :salary_payslips, :cash_bond, :boolean, default: false
  end
end
