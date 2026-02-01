require "net/http"
require "json"

class Line::Client
  PUSH_URL = URI("https://api.line.me/v2/bot/message/push")

  def self.push_text(to:, text:)
    token = ENV.fetch("LINE_MESSAGE_CHANNEL_ACCESS_TOKEN")

    req = Net::HTTP::Post.new(PUSH_URL)
    req["Content-Type"] = "application/json"
    req["Authorization"] = "Bearer #{token}"
    req.body = {
      to: to,
      messages: [ { type: "text", text: text } ]
    }.to_json

    response =
      Net::HTTP.start(PUSH_URL.host, PUSH_URL.port, use_ssl: true) do |http|
        http.request(req)
      end

    Rails.logger.info("[LINE] push status=#{response.code} body=#{response.body}")
    response
  end
end
