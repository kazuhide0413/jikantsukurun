class DailyHabitRecordsController < ApplicationController
  before_action :authenticate_user!

  def toggle
    today = Date.current

    # ✅ 常に「自分の習慣」から取得（テンプレート除外）
    habit = current_user.habits.find(params[:id])

    # ✅ 今日のレコードを探す or 新規作成
    record = habit.daily_habit_records.find_or_initialize_by(
      record_date: today,
      user_id: current_user.id
    )

    # ✅ 状態トグル & 時刻更新
    record.is_completed = !record.is_completed
    record.completed_at = record.is_completed ? Time.current : nil
    record.save!

    redirect_to habits_path, notice: "「#{habit.title}」を#{record.is_completed ? 'やった！' : '未完了に戻しました'}"
  end
end
