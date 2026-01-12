class AddLineNotificationFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :line_user_id, :string
    add_column :users, :line_notify_enabled, :boolean, default: false, null: false
    add_column :users, :line_linked_at, :datetime

    add_index :users, :line_user_id, unique: true
  end
end
