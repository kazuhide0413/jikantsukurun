class AddLineMessagingUserIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :line_messaging_user_id, :string
    add_index :users, :line_messaging_user_id, unique: true
  end
end
