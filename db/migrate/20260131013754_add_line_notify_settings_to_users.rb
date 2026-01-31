class AddLineNotifySettingsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :line_notify_enabled, :boolean, default: true, null: false
    add_column :users, :line_notify_time, :time, default: "12:00", null: false
    add_column :users, :line_last_sent_on, :date
  end
end
