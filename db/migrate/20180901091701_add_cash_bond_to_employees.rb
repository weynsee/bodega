class AddCashBondToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :cash_bond, :boolean, default: false
    Employee.half_monthly.update_all(cash_bond: true)
  end
end
