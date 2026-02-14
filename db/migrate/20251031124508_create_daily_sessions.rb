class CreateDailySessions < ActiveRecord::Migration[7.2]
  def change
    create_table :daily_sessions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.date :session_date
      t.datetime :return_home_at
      t.datetime :bedtime_at
      t.interval :effective_duration

      t.timestamps
    end
  end
end
