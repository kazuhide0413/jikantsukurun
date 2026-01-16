class LineWebhookController < ApplicationController
  skip_before_action :custom_authenticate_user!, raise: false
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :verify_authenticity_token

  def create
    body = request.body.read
    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    events = webhook_parser.parse(body: body, signature: signature)

    events.each do |event|
      next unless event.is_a?(Line::Bot::V2::Webhook::MessageEvent)
      next unless event.message.is_a?(Line::Bot::V2::Webhook::TextMessageContent)

      text = event.message.text
      line_user_id = event.source.user_id

      user = User.find_by(line_link_token: text)
      next if user.nil?

      user.update!(
        line_messaging_user_id: line_user_id,
        line_link_token: nil
      )

      Rails.logger.info(
        "[LINE] linked rails_user_id=#{user.id} line_user_id=#{line_user_id}"
      )
    end

    head :ok
  rescue Line::Bot::V2::WebhookParser::InvalidSignatureError
    Rails.logger.error("[LINE] Invalid signature")
    head :bad_request
  end

  private

  def webhook_parser
    @webhook_parser ||= Line::Bot::V2::WebhookParser.new(
      channel_secret: ENV.fetch("LINE_MESSAGE_CHANNEL_SECRET")
    )
  end
end
