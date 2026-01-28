class DailyHabitRecordsController < ApplicationController
  before_action :authenticate_user!

  def toggle
    habit = Habit.where(user_id: [current_user.id, nil]).find(params[:id])
    today = DailySession.logical_today

    record = DailyHabitRecord.find_or_create_by!(
      user_id: current_user.id,
      habit_id: habit.id,
      record_date: today
    )

    # 「やった！」は完了にする（トグルにしたいなら後述）
    record.update!(
      is_completed: true,
      completed_at: Time.current
    )

    redirect_to habits_path, notice: "「#{habit.title}」をやった！"
  end
end
