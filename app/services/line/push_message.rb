# app/services/line/push_message.rb
require "net/http"
require "uri"
require "json"

module Line
  class PushMessage
    ENDPOINT = "https://api.line.me/v2/bot/message/push"

    def initialize(to:, text:)
      @to = to
      @text = text
    end

    def call
      token = ENV.fetch("LINE_MESSAGING_CHANNEL_ACCESS_TOKEN")
      uri = URI.parse(ENDPOINT)

      req = Net::HTTP::Post.new(uri)
      req["Content-Type"] = "application/json"
      req["Authorization"] = "Bearer #{token}"

      req.body = {
        to: @to,
        messages: [{ type: "text", text: @text }]
      }.to_json

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      res = http.request(req)

      { status: res.code.to_i, body: res.body }
    end
  end
end
