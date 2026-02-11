require "net/http"
require "json"
require "jwt"

class LineIdTokenVerifier
  ISSUER = "https://access.line.me"
  JWKS_URL = "https://api.line.me/oauth2/v2.1/certs"

  def self.verify!(id_token)
    channel_id = ENV.fetch("LINE_LOGIN_CHANNEL_ID")

    jwks = fetch_jwks

    options = {
      algorithms: ["ES256"],   # ← ここを ES256 に
      iss: ISSUER,
      verify_iss: true,
      aud: channel_id,
      verify_aud: true
    }

    payload, = JWT.decode(id_token, nil, true, options) do |header|
      jwk = jwks.find { |k| k["kid"] == header["kid"] }
      raise JWT::DecodeError, "LINE JWKS kid not found" if jwk.nil?

      JWT::JWK.import(jwk).public_key
    end

    payload
  end

  def self.fetch_jwks
    uri = URI(JWKS_URL)
    res = Net::HTTP.get_response(uri)
    raise "Failed to fetch LINE JWKS: #{res.code}" unless res.is_a?(Net::HTTPSuccess)

    JSON.parse(res.body).fetch("keys")
  end
end
