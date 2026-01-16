class LineDailyEffectiveTimeNotifier
  def self.call(target_date:)
    # LINE連携済みのユーザーだけ対象
    User.where.not(line_messaging_user_id: [nil, ""]).find_each do |user|
      session = DailySession.find_by(user_id: user.id, session_date: target_date)
      next if session.nil?

      value = session.effective_duration
      next if value.nil?

      message = build_message(target_date, value)

      # 既に作ってあるJob
      LinePushNotificationJob.perform_later(user.id, message)
    end
  end

  def self.build_message(date, value)
    # effective_durationの単位（分）
    "【前日】#{date.strftime('%-m/%-d')} の有効時間は #{value} 分でした！"
  end
end
