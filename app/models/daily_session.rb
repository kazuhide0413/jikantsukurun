class DailySession < ApplicationRecord
  belongs_to :user

  validates :session_date, presence: true
  validates :user_id, uniqueness: { scope: :session_date, message: "は同じ日に複数セッションを作成できません" }

  # ------------------------------------------------------
  # 🕒 有効時間を計算して保存する
  # 「就寝時刻」 - 「今日の最後の習慣完了時刻」
  # ------------------------------------------------------
  def calculate_effective_duration!
    last_completed_at = user.daily_habit_records
                            .where(record_date: session_date, is_completed: true)
                            .where.not(completed_at: nil)
                            .maximum(:completed_at)

    if last_completed_at.nil? || bedtime_at.nil?
      update!(effective_duration: 0)
      return 0
    end

    duration = [(bedtime_at - last_completed_at).to_i, 0].max
    update!(effective_duration: duration)
    duration
  end

  # ------------------------------------------------------
  # 🏠 帰宅後かつ未就寝なら true（＝習慣ボタンが押せる状態）
  # ------------------------------------------------------
  def can_record_habits?
    return_home_at.present? && bedtime_at.blank?
  end

  # ------------------------------------------------------
  # ✅ 今日の全習慣が完了済みかどうか
  # ------------------------------------------------------
  def all_habits_completed_today?(target_habit_ids)
    done_ids = user.daily_habit_records
                    .where(record_date: session_date, is_completed: true)
                    .distinct
                    .pluck(:habit_id)
    (target_habit_ids - done_ids).empty?
  end

  # ------------------------------------------------------
  # ⏱ 有効時間を表示用フォーマットに変換
  # ------------------------------------------------------
  def formatted_effective_duration
    return nil unless effective_duration.present?
    hours = effective_duration / 3600
    minutes = (effective_duration % 3600) / 60
    "#{hours}時間#{minutes}分"
  end

  # ------------------------------------------------------
  # 📅 深夜帯を前日扱いにする「論理的な今日」
  # ------------------------------------------------------
  def self.logical_today(cutoff_hour = 4)
    now = Time.zone.now
    # 深夜0〜3時台は前日扱い
    now.hour < cutoff_hour ? (now - 1.day).to_date : now.to_date
  end
end
