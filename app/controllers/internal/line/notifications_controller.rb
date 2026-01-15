module Internal
  module Line
    class NotificationsController < ApplicationController
      # 外部（GitHub Actions）から叩くので、ログイン必須やCSRFで止めない
      skip_before_action :custom_authenticate_user!, raise: false
      skip_before_action :authenticate_user!, raise: false
      skip_before_action :verify_authenticity_token

      def daily_effective_time
        # 1) GitHub Actions だけ通す（トークン照合）
        token = request.headers["X-CRON-TOKEN"]
        return head :unauthorized if token.blank?

        expected = ENV.fetch("CRON_TOKEN")
        ok = ActiveSupport::SecurityUtils.secure_compare(token, expected)
        return head :unauthorized unless ok

        # 2) JSTで「前日」を計算して通知処理を呼ぶ
        Time.use_zone(ENV.fetch("APP_TIME_ZONE", "Asia/Tokyo")) do
          LineDailyEffectiveTimeNotifier.call(target_date: Time.zone.yesterday.to_date)
        end

        head :ok
      rescue => e
        Rails.logger.error("[CRON] daily_effective_time failed: #{e.class} #{e.message}")
        head :internal_server_error
      end
    end
  end
end
