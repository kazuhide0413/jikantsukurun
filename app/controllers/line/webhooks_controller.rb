class Line::WebhooksController < ApplicationController
  skip_before_action :custom_authenticate_user!, raise: false
  skip_before_action :verify_authenticity_token

  def callback
    body = request.raw_post
    signature = request.headers["X-Line-Signature"]

    unless Line::SignatureVerifier.valid?(body, signature)
      Rails.logger.warn("[LINE] invalid signature")
      head :bad_request and return
    end

    events = JSON.parse(body).fetch("events", [])

    events.each do |event|
      type = event["type"]
      user_id = event.dig("source", "userId")

      Rails.logger.info("[LINE] type=#{type} userId=#{user_id}")
    end

    head :ok
  rescue JSON::ParserError
    head :bad_request
  end
end
