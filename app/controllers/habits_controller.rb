class HabitsController < ApplicationController
  before_action :authenticate_user!  # Devise使用時
  # before_action :set_habit, only: [:show, :edit, :update, :destroy]

  def index
    user_habits = Habit.where(user: current_user)
    default_habits = Habit.default_habits
    @habits = (user_habits + default_habits).uniq { |h| h.title }
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

  private

  def set_habit
    @habit = current_user.habits.find(params[:id])
  end

  def habit_params
    params.require(:habit).permit(:title)
  end
end
