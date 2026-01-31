# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: [ :google_oauth2, :line_v2_1 ]

  def google_oauth2
    callback_for(:google)
  end

  def line_v2_1
    callback_for(:line)
  end

  private

  def callback_for(provider)
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)

    if @user.persisted?
      if provider == :line && @user.line_messaging_user_id.blank?
        @user.update!(line_messaging_user_id: auth.uid)
      end

      @user.remember_me = true

      sign_in(:user, @user, event: :authentication)

      set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?

      redirect_to after_sign_in_path_for(@user)
      return
    end

    session["devise.#{provider}_data"] = auth.except(:extra)
    flash[:alert] = @user.errors.full_messages.to_sentence if @user.errors.any?
    redirect_to new_user_registration_url
  rescue => e
    Rails.logger.warn("[OmniAuth] #{provider} failed: #{e.class} #{e.message}")
    redirect_to new_user_session_path, alert: "ログインに失敗しました"
  end

  def failure
    redirect_to root_path, alert: "ログインに失敗しました。もう一度お試しください。"
  end
end
