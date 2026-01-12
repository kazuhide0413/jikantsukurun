class LineWebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    body = request.raw_post
    signature = request.headers["X-Line-Signature"].to_s

    unless valid_signature?(body, signature)
      Rails.logger.warn("[LINE] invalid signature")
      head :bad_request and return
    end

    payload = JSON.parse(body)
    events = payload["events"] || []

    events.each do |event|
      next unless event["type"] == "message"
      next unless event.dig("message", "type") == "text"

      text = event.dig("message", "text").to_s.strip
      line_user_id = event.dig("source", "userId").to_s

      user = User.find_by(line_link_token: text)
      next if user.nil?

      user.update!(
        line_user_id: line_user_id,
        line_linked_at: Time.zone.now,
        line_link_token: nil,
        line_link_token_generated_at: nil
      )

      Rails.logger.info("[LINE] linked user_id=#{user.id}")
    end

    head :ok
  rescue JSON::ParserError
    head :bad_request
  end

  private

  def valid_signature?(body, signature)
    secret = ENV.fetch("LINE_MESSAGING_CHANNEL_SECRET", "")
    return false if secret.blank? || signature.blank?

    hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), secret, body)
    computed = Base64.strict_encode64(hash)
    ActiveSupport::SecurityUtils.secure_compare(computed, signature)
  end
end
