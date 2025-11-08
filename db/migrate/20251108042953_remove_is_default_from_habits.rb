class RemoveIsDefaultFromHabits < ActiveRecord::Migration[7.2]
  def change
    remove_column :habits, :is_default, :boolean, default: false, null: false
  end
end
