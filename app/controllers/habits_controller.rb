class HabitsController < ApplicationController
  before_action :authenticate_user!  # Devise使用時
  before_action :set_habit, only: [:show, :edit, :update, :destroy]

  def index
    user_habits = Habit.where(user: current_user)
    default_habits = Habit.default_habits
    @habits = (user_habits + default_habits).uniq { |h| h.title }

    # 👇 追加：今日完了済みの習慣IDを取得
    today = Date.current
    @completed_habit_ids = DailyHabitRecord.where(record_date: today, is_completed: true).pluck(:habit_id)
  end

  def show
    @habit = Habit.where(user_id: [current_user.id, nil]).find(params[:id])
    @today_record = @habit.daily_habit_records.find_by(record_date: Date.current)
  end

  def new
    @habit = Habit.new
  end

  def create
    @habit = current_user.habits.build(habit_params)
    if @habit.save
      redirect_to habits_path, notice: "新しい習慣を追加しました！"
    else
      flash.now[:alert] = "保存に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @habit.update(habit_params)
      redirect_to habit_path(@habit), notice: "習慣を更新しました！"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @habit.destroy
    redirect_to habits_path, notice: "習慣を削除しました。"
  end

  private

  def set_habit
    @habit = Habit.find_by(id: params[:id])

    # 存在しない or 他人の習慣なら404
    if @habit.nil? || (@habit.user.present? && @habit.user != current_user)
      raise ActiveRecord::RecordNotFound, "Habit not found"
    end
  end

  def habit_params
    params.require(:habit).permit(:title)
  end
end
