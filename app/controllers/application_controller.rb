class ApplicationController < ActionController::Base

  # CSRF攻撃対策
  protect_from_forgery with: :exception

  # カスタム認証を使用
  before_action :custom_authenticate_user!, unless: :public_page?

  # deviseコントローラーにストロングパラメータを追加する  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # カスタム認証メソッド
  def custom_authenticate_user!
    return if user_signed_in?
    redirect_to new_user_session_path, alert: 'ログインが必要です。'
  end

  private

  # 公開ページ（ログイン不要）の判定
  def public_page?
  # ルートページとDeviseページは公開
    (controller_name == 'static_pages' && action_name == 'top') ||
    devise_controller?
  end
end
