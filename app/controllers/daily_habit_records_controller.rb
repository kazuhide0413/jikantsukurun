class DailyHabitRecordsController < ApplicationController
  before_action :authenticate_user!

  # 将来的に他のアクション（index等）を入れる余地あり
  def toggle
    habit = current_user.habits.find(params[:habit_id])
    today = Date.current

    record = habit.daily_habit_records.find_or_initialize_by(record_date: today)

    # トグル処理
    record.is_completed = !record.is_completed
    record.completed_at = record.is_completed ? Time.current : nil
    record.save!

    redirect_to habit_path(habit), notice: "「#{habit.title}」を#{record.completed ? 'やった！' : '未完了に戻しました'}"
  end
end
