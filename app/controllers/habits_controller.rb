class HabitsController < ApplicationController
  def index
    user_habits = Habit.where(user: current_user)
    default_habits = Habit.default_habits
    @habits = (user_habits + default_habits).uniq { |h| h.title }
  end
end
