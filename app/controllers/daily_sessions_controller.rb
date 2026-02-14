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

    unless daily_session.return_home_at.present?
      redirect_to habits_path, alert: "先に『帰宅』を記録してください。"
      return
    end

    target_ids = current_user.habits.pluck(:id)

    unless daily_session.all_habits_completed_today?(target_ids)
      redirect_to habits_path, alert: "未完了の習慣があります。すべて完了してから『就寝』してください。"
      return
    end

    daily_session.update!(bedtime_at: Time.current)
    daily_session.reload
    daily_session.calculate_effective_duration!

    dur = daily_session.effective_duration.to_i
    hours = dur / 3600
    minutes = (dur % 3600) / 60

    redirect_to habits_path, notice: "おやすみなさい😴 有効時間：#{hours}時間#{minutes}分"
  end

  def index
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
    start_date  = @start_date.beginning_of_month
    end_date    = @start_date.end_of_month

    sessions = current_user.daily_sessions
                           .where(session_date: start_date..end_date)
                           .order(:session_date)

    @sessions_by_date = sessions.index_by(&:session_date)

    # ✅ 背景色用：日付 => 分（integer）
    @minutes_by_date = {}
    (start_date..end_date).each do |date|
      dur = @sessions_by_date[date]&.effective_duration.to_i # 秒（nilなら0）
      @minutes_by_date[date] = (dur / 60)                    # 分
    end

    data = {}
    (start_date..end_date).each do |date|
      s = @sessions_by_date[date]
      data[date.strftime("%Y-%m-%d")] = s&.formatted_effective_duration
    end

    respond_to do |format|
      format.html
      format.json { render json: data }
    end
  end

  private

  # ------------------------------------------------------
  # 📅 今日のセッションを取得（深夜も前日扱い対応）
  # ------------------------------------------------------
  def find_today_session
    DailySession.find_or_create_by!(
      user: current_user,
      session_date: DailySession.logical_today
    )
  end
end
