class CreateDefaultHabits < ActiveRecord::Migration[7.2]
  def change
    create_table :default_habits do |t|
      t.string :title, null: false

      t.timestamps
    end

    add_index :default_habits, :title, unique: true
  end
end
