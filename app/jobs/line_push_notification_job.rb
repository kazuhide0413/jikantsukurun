class LinePushNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id, text)
    user = User.find_by(id: user_id)
    return if user.nil?
    return if user.line_messaging_user_id.blank?

    LineMessagingClient.push_text(
      to: user.line_messaging_user_id,
      text: text
    )
  rescue => e
    Rails.logger.error("[LINE_PUSH_JOB] #{e.class}: #{e.message}")
  end
end
