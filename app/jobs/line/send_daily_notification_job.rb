class Line::SendDailyNotificationJob < ApplicationJob
  queue_as :default

  WINDOW = 5.minutes

  def perform(now: Time.zone.now)
    today = now.to_date

    targets(now).find_each do |user|
      next if already_sent_today?(user, today)

      notify_at = build_notify_at(user, now)
      next unless in_window?(now, notify_at)

      text = "おかえりなさい！昨日もおつかれさまでした。今日も頑張りましょう💪"
      Line::Client.push_text(to: user.line_messaging_user_id, text: text)

      user.update!(line_last_sent_on: today)
    end
  end

  private

  def targets(now)
    # 通知ONで、送り先IDがあるユーザーだけ
    User.where(line_notify_enabled: true)
        .where.not(line_messaging_user_id: [nil, ""])
  end

  def already_sent_today?(user, today)
    # 多重送信防止：今日すでに送ったなら送らない
    user.line_last_sent_on == today
  end

  def build_notify_at(user, now)
    t = user.line_notify_time
    # 「今日の日付 + ユーザーの時刻」で、今日の通知予定時刻を作る
    Time.zone.local(now.year, now.month, now.day, t.hour, t.min, 0)
  end

  def in_window?(now, notify_at)
    # Cronが5分おきなので「その5分の間に入ってたら送る」
    now >= notify_at && now < notify_at + WINDOW
  end
end
