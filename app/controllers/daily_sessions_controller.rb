class DailySessionsController < ApplicationController
  before_action :authenticate_user!

  # ------------------------------------------------------
  # 🏠 帰宅ボタン
  # ------------------------------------------------------
  def return_home
    daily_session = find_today_session
    if daily_session.return_home_at.present?
      redirect_to habits_path, notice: "すでに『帰宅』は記録済みです。"
    else
      daily_session.update!(return_home_at: Time.current)
      redirect_to habits_path, notice: "『帰宅』を記録しました。"
    end
  end

  # ------------------------------------------------------
  # 💤 就寝ボタン
  # ------------------------------------------------------
  def bedtime
    daily_session = find_today_session

    # 帰宅していないのに就寝ボタンを押した場合
    unless daily_session.return_home_at.present?
      redirect_to habits_path, alert: "先に『帰宅』を記録してください。"
      return
    end

    # ユーザーの全習慣を取得
    target_ids = current_user.habits.pluck(:id)

    # 未完了の習慣がある場合は就寝できない
    unless daily_session.all_habits_completed_today?(target_ids)
      redirect_to habits_path, alert: "未完了の習慣があります。すべて完了してから『就寝』してください。"
      return
    end

    # 就寝時刻を保存して有効時間を計算
    daily_session.update!(bedtime_at: Time.current)
    daily_session.calculate_effective_duration!

    dur = daily_session.effective_duration.to_i
    hours = dur / 3600
    minutes = (dur % 3600) / 60

    redirect_to habits_path, notice: "おやすみなさい😴 有効時間：#{hours}時間#{minutes}分"
  end

  private

  # ------------------------------------------------------
  # 📅 今日のセッションを取得（なければ作成）
  # ------------------------------------------------------
  def find_today_session
    DailySession.find_or_create_by!(user: current_user, session_date: Date.current)
  end
end
