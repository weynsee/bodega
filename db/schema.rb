# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_15_054537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.bigint "employee_id"
    t.integer "attendance_type", default: 0, null: false
    t.float "amount", null: false
    t.date "applies_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "applies_on", "attendance_type"], name: "index_attendance_on_employee_type_and_date", unique: true
    t.index ["employee_id"], name: "index_attendances_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name", null: false
    t.float "rate", null: false
    t.integer "rate_type", default: 0, null: false
    t.float "rice_allowance_rate", null: false
    t.float "overtime_rate", null: false
    t.float "month_end_rate"
    t.float "year_end_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.boolean "cash_bond", default: false
    t.index ["name"], name: "index_employees_on_name"
  end

  create_table "month_end_advances", force: :cascade do |t|
    t.bigint "employee_id"
    t.integer "advance_type", default: 0, null: false
    t.float "amount", null: false
    t.string "applies_on", null: false
    t.bigint "month_end_payslip_id"
    t.string "description"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "issue_date", null: false
    t.index ["employee_id", "applies_on"], name: "index_month_end_advances_on_employee_id_and_applies_on"
    t.index ["employee_id"], name: "index_month_end_advances_on_employee_id"
    t.index ["month_end_payslip_id"], name: "index_month_end_advances_on_month_end_payslip_id"
  end

  create_table "month_end_payslips", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "applies_on", null: false
    t.float "days_present", null: false
    t.float "rate", null: false
    t.float "total", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "issue_date", null: false
    t.index ["employee_id", "applies_on"], name: "index_month_end_payslips_on_employee_id_and_applies_on", unique: true
    t.index ["employee_id"], name: "index_month_end_payslips_on_employee_id"
  end

  create_table "overtime_payslips", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "applies_on", null: false
    t.float "hours", null: false
    t.float "rate", null: false
    t.float "total", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "issue_date", null: false
    t.index ["employee_id", "applies_on"], name: "index_overtime_payslips_on_employee_id_and_applies_on", unique: true
    t.index ["employee_id"], name: "index_overtime_payslips_on_employee_id"
  end

  create_table "rice_allowance_advances", force: :cascade do |t|
    t.bigint "employee_id"
    t.integer "advance_type", default: 0, null: false
    t.float "amount", null: false
    t.string "applies_on", null: false
    t.bigint "rice_allowance_payslip_id"
    t.string "description"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "issue_date", null: false
    t.index ["employee_id", "applies_on"], name: "index_rice_allowance_advances_on_employee_id_and_applies_on"
    t.index ["employee_id"], name: "index_rice_allowance_advances_on_employee_id"
    t.index ["rice_allowance_payslip_id"], name: "index_rice_allowance_advances_on_rice_allowance_payslip_id"
  end

  create_table "rice_allowance_payslips", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "applies_on", null: false
    t.float "days_present", null: false
    t.float "rate", null: false
    t.float "total", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "issue_date", null: false
    t.index ["employee_id", "applies_on"], name: "index_rice_allowance_payslips_on_employee_id_and_applies_on", unique: true
    t.index ["employee_id"], name: "index_rice_allowance_payslips_on_employee_id"
  end

  create_table "salary_advances", force: :cascade do |t|
    t.bigint "employee_id"
    t.integer "advance_type", default: 0, null: false
    t.integer "salary_type", null: false
    t.float "amount", null: false
    t.string "applies_on", null: false
    t.bigint "salary_payslip_id"
    t.string "description"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "issue_date", null: false
    t.index ["employee_id", "salary_type", "applies_on"], name: "index_salary_advances_on_employee_id_and_salary_type_and_date"
    t.index ["employee_id"], name: "index_salary_advances_on_employee_id"
    t.index ["salary_payslip_id"], name: "index_salary_advances_on_salary_payslip_id"
  end

  create_table "salary_payslips", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "applies_on", null: false
    t.float "days_present", null: false
    t.integer "salary_type", null: false
    t.float "rate", null: false
    t.float "total", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "issue_date", null: false
    t.boolean "cash_bond", default: false
    t.index ["employee_id", "applies_on"], name: "index_salary_payslips_on_employee_id_and_applies_on", unique: true
    t.index ["employee_id"], name: "index_salary_payslips_on_employee_id"
  end

  create_table "year_end_advances", force: :cascade do |t|
    t.bigint "employee_id"
    t.integer "advance_type", default: 0, null: false
    t.float "amount", null: false
    t.string "applies_on", null: false
    t.bigint "year_end_payslip_id"
    t.string "description"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "issue_date", null: false
    t.index ["employee_id", "applies_on"], name: "index_year_end_advances_on_employee_id_and_applies_on"
    t.index ["employee_id"], name: "index_year_end_advances_on_employee_id"
    t.index ["year_end_payslip_id"], name: "index_year_end_advances_on_year_end_payslip_id"
  end

  create_table "year_end_payslips", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "applies_on", null: false
    t.float "days_present", null: false
    t.float "rate", null: false
    t.float "total", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "issue_date", null: false
    t.index ["employee_id", "applies_on"], name: "index_year_end_payslips_on_employee_id_and_applies_on", unique: true
    t.index ["employee_id"], name: "index_year_end_payslips_on_employee_id"
  end

  add_foreign_key "attendances", "employees"
  add_foreign_key "month_end_advances", "employees"
  add_foreign_key "month_end_advances", "month_end_payslips"
  add_foreign_key "month_end_payslips", "employees"
  add_foreign_key "overtime_payslips", "employees"
  add_foreign_key "rice_allowance_advances", "employees"
  add_foreign_key "rice_allowance_advances", "rice_allowance_payslips"
  add_foreign_key "rice_allowance_payslips", "employees"
  add_foreign_key "salary_advances", "employees"
  add_foreign_key "salary_advances", "salary_payslips"
  add_foreign_key "salary_payslips", "employees"
  add_foreign_key "year_end_advances", "employees"
  add_foreign_key "year_end_advances", "year_end_payslips"
  add_foreign_key "year_end_payslips", "employees"
end
