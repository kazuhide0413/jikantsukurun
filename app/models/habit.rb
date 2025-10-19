class Habit < ApplicationRecord
  belongs_to :user
  has_many :daily_habit_records, dependent: :destroy

  validates :title, presence: true
end
