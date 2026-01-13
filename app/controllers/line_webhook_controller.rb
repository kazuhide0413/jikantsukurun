class LineWebhookController < ApplicationController
  skip_before_action :custom_authenticate_user!, raise: false
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :verify_authenticity_token

  def create
    body = request.body.read
    signature = request.env["HTTP_X_LINE_SIGNATURE"]

    events = webhook_parser.parse(body: body, signature: signature)

    events.each do |event|
      Rails.logger.info("[LINE] event=#{event.class.name}")

      if event.is_a?(Line::Bot::V2::Webhook::MessageEvent) &&
         event.message.is_a?(Line::Bot::V2::Webhook::TextMessageContent)
        Rails.logger.info("[LINE] text=#{event.message.text} user_id=#{event.source.user_id}")
      end
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
