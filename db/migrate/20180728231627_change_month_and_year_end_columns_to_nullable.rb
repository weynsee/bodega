class ChangeMonthAndYearEndColumnsToNullable < ActiveRecord::Migration[5.2]
  def change
    change_column_null :employees, :month_end_rate, true
    change_column_null :employees, :year_end_rate, true
  end
end
