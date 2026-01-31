class ChangeDefaultForLineNotifyEnabledInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :line_notify_enabled, false
  end
end
