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

ActiveRecord::Schema.define(version: 20210403150609) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "finish_time"
    t.string "aim"
    t.integer "next_day"
    t.string "instructor"
    t.string "instructor_confirmation"
    t.boolean "change"
    t.string "attendance_instructor"
    t.boolean "attendance_change"
    t.string "attendance_confirmation"
    t.datetime "started_at_temporary"
    t.datetime "finished_at_temporary"
    t.boolean "one_month_next"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logs", force: :cascade do |t|
    t.date "log_worked_on"
    t.time "before_started"
    t.time "before_finished"
    t.time "after_started"
    t.time "after_finished"
    t.string "log_instructor"
    t.date "approval_day"
    t.integer "attendance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendance_id"], name: "index_logs_on_attendance_id"
  end

  create_table "months", force: :cascade do |t|
    t.string "one_month_instructor"
    t.string "one_month_confirmation"
    t.boolean "one_month_change"
    t.integer "year"
    t.integer "month"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_months_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "affiliation"
    t.time "basic_work_time"
    t.time "designated_work_start_time"
    t.time "designated_work_end_time"
    t.boolean "superior", default: false
    t.integer "employee_number"
    t.integer "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_number"], name: "index_users_on_employee_number", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

end
