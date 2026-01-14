class AddLineLinkTokenToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :line_link_token, :string
    add_index :users, :line_link_token, unique: true
  end
end
