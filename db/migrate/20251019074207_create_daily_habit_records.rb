class CreateDailyHabitRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :daily_habit_records, id: :uuid do |t|
      t.references :habit, null: false, foreign_key: true, type: :uuid
      t.date :record_date, null: false
      t.boolean :is_completed, default: false, null: false
      t.datetime :completed_at

      t.timestamps
    end

    add_index :daily_habit_records, [:habit_id, :record_date], unique: true
  end
end
