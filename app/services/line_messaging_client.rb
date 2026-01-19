class LineMessagingClient
  def self.client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: ENV.fetch("LINE_MESSAGE_CHANNEL_ACCESS_TOKEN")
    )
  end

  def self.push_text(to:, text:)
    raise ArgumentError, "to is blank" if to.blank?

    req = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
      to: to,
      messages: [ Line::Bot::V2::MessagingApi::TextMessage.new(text: text) ]
    )

    client.push_message(push_message_request: req)
  end
end
