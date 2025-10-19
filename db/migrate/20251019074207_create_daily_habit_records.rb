class CreateDailyHabitRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :daily_habit_records do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :record_date
      t.boolean :is_completed
      t.datetime :completed_at

      t.timestamps
    end
  end
end
