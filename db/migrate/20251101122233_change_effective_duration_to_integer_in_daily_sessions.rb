class ChangeEffectiveDurationToIntegerInDailySessions < ActiveRecord::Migration[7.2]
  def change
    change_column :daily_sessions, :effective_duration, :integer, using: "extract(epoch from effective_duration)"
  end
end
