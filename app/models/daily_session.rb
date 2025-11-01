class DailySession < ApplicationRecord
  belongs_to :user

  validates :session_date, presence: true
  validates :user_id, uniqueness: { scope: :session_date, message: "は同じ日に複数セッションを作成できません" }

  # 有効時間を計算して保存するメソッド
  def calculate_effective_duration!
    last_completed_at = user.daily_habit_records
                            .where(record_date: session_date, is_completed: true)
                            .maximum(:completed_at)
    return unless bedtime_at && last_completed_at
    update!(effective_duration: bedtime_at - last_completed_at)
  end
end
