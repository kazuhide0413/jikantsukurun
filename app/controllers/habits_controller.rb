class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: [:show, :edit, :update, :destroy]

  def index
    @habits = current_user.habits
    @today_session = current_user.daily_sessions.find_or_create_by(session_date: Date.current)

    today = Date.current
    records = DailyHabitRecord
                .where(record_date: today, habit_id: @habits.pluck(:id), is_completed: true)
                .pluck(:habit_id)
    @completed_habit_ids = records
  end

  def show
    @habit = Habit.where(user_id: [current_user.id, nil]).find(params[:id])
    @today_record = @habit.daily_habit_records.find_by(record_date: Date.current)
  end

  # ✅ newアクションに就寝チェックを追加
  def new
    today_session = current_user.daily_sessions.find_by(session_date: Date.current)

    if today_session&.bedtime_at.present?
      redirect_to habits_path, alert: "本日は就寝済みのため、新しい習慣は登録できません。"
    else
      @habit = Habit.new
    end
  end

  def create
    today_session = current_user.daily_sessions.find_by(session_date: Date.current)

    # 💤 就寝済みなら登録禁止
    if today_session&.bedtime_at.present?
      redirect_to habits_path, alert: "本日はすでに就寝済みのため、新しい習慣は登録できません。"
      return
    end

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
    if @habit.nil? || (@habit.user.present? && @habit.user != current_user)
      raise ActiveRecord::RecordNotFound, "Habit not found"
    end
  end

  def habit_params
    params.require(:habit).permit(:title)
  end
end
