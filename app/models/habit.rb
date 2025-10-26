class Habit < ApplicationRecord
  belongs_to :user, optional: true
  has_many :daily_habit_records, dependent: :destroy

  validates :title, presence: true
  validates :title, uniqueness: { scope: :user_id, message: "はすでに登録されています" }
  validate :title_cannot_duplicate_default

  scope :default_habits, -> { where(is_default: true) }

  private

  # デフォルト習慣と同名タイトルは禁止
  def title_cannot_duplicate_default
    if user_id.present? && Habit.default_habits.exists?(title: title)
      # 👇 メッセージを統一（Rails標準のuniquenessと同じ）
      errors.add(:title, "はすでに登録されています")
    end
  end

end
