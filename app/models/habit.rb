class Habit < ApplicationRecord
  belongs_to :user, optional: true
  has_many :daily_habit_records, dependent: :destroy

  validates :title, presence: true

  scope :default_habits, -> { where(is_default: true) }
end
