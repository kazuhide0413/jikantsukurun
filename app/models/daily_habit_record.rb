class DailyHabitRecord < ApplicationRecord
  belongs_to :user
  belongs_to :habit

  validates :record_date, presence: true
  validates :habit_id, uniqueness: { scope: [:user_id, :record_date],
    message: "は同じ日に重複登録できません" }
  validates :is_completed, inclusion: { in: [true, false] }

  scope :for_date, ->(date) { where(record_date: date) }
  scope :today, -> { for_date(Date.current) }
  scope :completed, -> { where(is_completed: true) }
  scope :incomplete, -> { where(is_completed: false) }

  # 完了状態の判定メソッド
  def completed?
    is_completed
  end

  # 習慣完了の切り替え
  def toggle_completion!
    if completed?
      update!(is_completed: false, completed_at: nil)
    else
      update!(is_completed: true, completed_at: Time.current)
    end
  end
end
