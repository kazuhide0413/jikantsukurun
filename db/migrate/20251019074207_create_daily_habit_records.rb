class CreateDailyHabitRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :daily_habit_records do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :record_date, null: false
      t.boolean :is_completed, default: false, null: false
      t.datetime :completed_at

      t.timestamps
    end

    # habit_id と record_date の組み合わせで一意制約
    add_index :daily_habit_records, [:habit_id, :record_date], unique: true
  end
end
