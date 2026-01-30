require "base64"
require "openssl"

class Line::SignatureVerifier
  def self.valid?(body, signature)
    return false if signature.blank?

    secret = ENV.fetch("LINE_MESSAGE_CHANNEL_SECRET", "")
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), secret, body)
    expected = Base64.strict_encode64(hash)

    ActiveSupport::SecurityUtils.secure_compare(expected, signature)
  end
end
