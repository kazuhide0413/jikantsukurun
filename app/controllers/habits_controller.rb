class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: %i[show edit update destroy]
  before_action :prevent_modification_after_bedtime,
                only: %i[new create edit update destroy]

  def index
    @habits = current_user.habits

    @today_session =
      current_user.daily_sessions.find_or_create_by(
        session_date: DailySession.logical_today
      )

    today = DailySession.logical_today

    records =
      DailyHabitRecord
        .where(
          user_id: current_user.id,
          record_date: today,
          habit_id: @habits.pluck(:id),
          is_completed: true
        )
        .pluck(:habit_id)

    @completed_habit_ids = records
  end

  def show
    @habit =
      Habit
        .where(user_id: [ current_user.id, nil ])
        .find(params[:id])

    @today_record =
      DailyHabitRecord.find_by(
        user_id: current_user.id,
        habit_id: @habit.id,
        record_date: DailySession.logical_today
      )
  end

  def new
    @habit = Habit.new
  end

  def create
    @habit = current_user.habits.build(habit_params)

    if @habit.save
      redirect_to habits_path, notice: t("habits.flash.created")
    else
      flash.now[:alert] = t("habits.flash.create_failed")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @habit.update(habit_params)
      redirect_to habit_path(@habit), notice: t("habits.flash.updated")
    else
      flash.now[:alert] = t("habits.flash.update_failed")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @habit.destroy
    redirect_to habits_path, notice: t("habits.flash.destroyed")
  end

  private

  # ------------------------------------------------------
  # 🚫 「就寝後」は登録・編集・削除を禁止
  # ------------------------------------------------------
  def prevent_modification_after_bedtime
    today_session =
      current_user.daily_sessions.find_by(
        session_date: DailySession.logical_today
      )

    if today_session&.bedtime_at.present?
      redirect_to habits_path,
                  alert: t("habits.flash.after_bedtime_forbidden")
    end
  end

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
