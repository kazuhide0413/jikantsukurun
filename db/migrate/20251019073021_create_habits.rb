class CreateHabits < ActiveRecord::Migration[7.2]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.boolean :is_default, default: false, null: false

      t.timestamps
    end
  end
end
