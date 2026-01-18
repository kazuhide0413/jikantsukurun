# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :custom_authenticate_user!, unless: :public_page?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def custom_authenticate_user!
    return if user_signed_in?
    redirect_to new_user_session_path, alert: "ログインが必要です。"
  end

  private

  def public_page?
    # ルートページとDeviseページは公開
    return true if (controller_name == "static_pages" && action_name == "top")
    return true if devise_controller?

    # high_voltage の利用規約/PPも公開（/pages/terms, /pages/policy）
    controller_path == "high_voltage/pages" && %w[terms policy].include?(params[:id])
  end
end
