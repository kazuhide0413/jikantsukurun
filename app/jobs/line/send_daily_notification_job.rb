class Line::SendDailyNotificationJob < ApplicationJob
  queue_as :default

  WINDOW = 5.minutes

  def perform(now: Time.zone.now)
    today = now.to_date

    targets(now).find_each do |user|
      next if already_sent_today?(user, today)

      notify_at = build_notify_at(user, now)
      next unless in_window?(now, notify_at)

      text = build_text_for(user, now)

      Line::Client.push_text(to: user.line_messaging_user_id, text: text)
      user.update!(line_last_sent_on: today)
    end
  end

  private

  def targets(_now)
    User.where(line_notify_enabled: true)
        .where.not(line_messaging_user_id: [nil, ""])
  end

  def already_sent_today?(user, today)
    user.line_last_sent_on == today
  end

  def build_notify_at(user, now)
    t = user.line_notify_time
    Time.zone.local(now.year, now.month, now.day, t.hour, t.min, 0)
  end

  def in_window?(now, notify_at)
    now >= notify_at && now < notify_at + WINDOW
  end

  # ✅ ここが追加：昨日の結果メッセージ
  def build_text_for(user, now)
    yday = (now.to_date - 1)

    records = DailyHabitRecord.where(user_id: user.id, record_date: yday)
    total = records.count
    done  = records.where(is_completed: true).count

    # 昨日の記録がまだ無い人向け
    if total.zero?
      return "おかえりなさい！昨日の習慣記録がまだありません。今日から一緒に積み上げましょう💪"
    end

    if done == total
      "おかえりなさい！昨日の習慣は #{done}/#{total} で全て完了でした🎉 今日も頑張りましょう💪"
    else
      "おかえりなさい！昨日の習慣達成は #{done}/#{total} でした。今日も少しずついきましょう💪"
    end
  end
end
