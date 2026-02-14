class AddUserIdToDailyHabitRecords < ActiveRecord::Migration[7.2]
  def change
    add_reference :daily_habit_records, :user, null: false, foreign_key: true, type: :uuid

    # すでに存在する unique index があるので、一度削除して作り直す
    remove_index :daily_habit_records, [:habit_id, :record_date]
    add_index :daily_habit_records, [:user_id, :habit_id, :record_date], unique: true
  end
end
