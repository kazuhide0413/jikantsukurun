class CreateHabits < ActiveRecord::Migration[7.2]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.boolean :is_default

      t.timestamps
    end
  end
end
