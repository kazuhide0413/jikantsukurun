class Habit < ApplicationRecord
  belongs_to :user
  has_many :daily_habit_records, dependent: :destroy

  validates :title, presence: true
  validates :title, uniqueness: { scope: :user_id, message: "はすでに登録されています" }
end
