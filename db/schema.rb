# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_01_14_133106) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daily_habit_records", force: :cascade do |t|
    t.bigint "habit_id", null: false
    t.date "record_date", null: false
    t.boolean "is_completed", default: false, null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["habit_id"], name: "index_daily_habit_records_on_habit_id"
    t.index ["user_id", "habit_id", "record_date"], name: "idx_on_user_id_habit_id_record_date_2c762ec563", unique: true
    t.index ["user_id"], name: "index_daily_habit_records_on_user_id"
  end

  create_table "daily_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "session_date", null: false
    t.datetime "return_home_at"
    t.datetime "bedtime_at"
    t.integer "effective_duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "session_date"], name: "index_daily_sessions_on_user_id_and_session_date", unique: true
    t.index ["user_id"], name: "index_daily_sessions_on_user_id"
  end

  create_table "default_habits", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_default_habits_on_title", unique: true
  end

  create_table "habits", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_habits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "provider"
    t.string "uid"
    t.string "avatar_url"
    t.string "line_messaging_user_id"
    t.string "line_link_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["line_link_token"], name: "index_users_on_line_link_token", unique: true
    t.index ["line_messaging_user_id"], name: "index_users_on_line_messaging_user_id", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "daily_habit_records", "habits"
  add_foreign_key "daily_habit_records", "users"
  add_foreign_key "daily_sessions", "users"
  add_foreign_key "habits", "users"
end
