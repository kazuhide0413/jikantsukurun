class ChangeUserIdToBeNullableInHabits < ActiveRecord::Migration[7.2]
  def change
    change_column_null :habits, :user_id, true
  end
end
