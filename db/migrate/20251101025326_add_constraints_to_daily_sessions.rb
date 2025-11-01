class AddConstraintsToDailySessions < ActiveRecord::Migration[7.2]
  def change
    # session_date を NOT NULL にする
    change_column_null :daily_sessions, :session_date, false

    # 同じユーザーが同じ日に複数のセッションを作れないようにする
    add_index :daily_sessions, [:user_id, :session_date], unique: true
  end
end
