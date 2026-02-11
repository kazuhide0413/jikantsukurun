class LiffController < ApplicationController
  skip_before_action :custom_authenticate_user!, only: %i[show auth]
  skip_before_action :verify_authenticity_token, only: :auth

  def show
    @liff_id = ENV.fetch("LIFF_ID")
  end

  def auth
    id_token = params[:id_token].to_s
    return render json: { ok: false, error: "id_token is blank" }, status: :bad_request if id_token.blank?

    payload = LineIdTokenVerifier.verify!(id_token)
    line_sub = payload.fetch("sub")

    user =
      User.find_by(provider: "line_v2_1", uid: line_sub) ||
      User.find_by(line_messaging_user_id: line_sub)

    return render json: { ok: false, error: "user not found for this LINE account" }, status: :unauthorized if user.nil?

    sign_in(user)
    render json: { ok: true, redirect_to: root_path }
  rescue JWT::DecodeError, JWT::IncorrectAlgorithm => e
    render json: { ok: false, error: e.message }, status: :unauthorized
  end
end
