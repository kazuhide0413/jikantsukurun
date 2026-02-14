class CreateHabits < ActiveRecord::Migration[7.2]
  def change
    create_table :habits, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.boolean :is_default, default: false, null: false

      t.timestamps
    end
  end
end
