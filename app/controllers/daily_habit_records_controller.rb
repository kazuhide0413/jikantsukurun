class DailyHabitRecordsController < ApplicationController
  before_action :authenticate_user!

  def toggle
    habit = Habit.where(user_id: [current_user.id, nil]).find(params[:id])
    today = Date.current

    record = habit.daily_habit_records.find_or_initialize_by(record_date: today, user_id: current_user.id)
    record.is_completed = !record.is_completed
    record.completed_at = record.is_completed ? Time.current : nil
    record.save!

    redirect_to habits_path, notice: "「#{habit.title}」を#{record.is_completed ? 'やった！' : '未完了に戻しました'}"
  end
end
