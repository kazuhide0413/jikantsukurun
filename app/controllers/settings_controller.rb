class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit_name
    @user = current_user
  end

  def update_name
    @user = current_user
    if @user.update(user_params)
      redirect_to settings_path, notice: "ユーザー名を更新しました！"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit_name, status: :unprocessable_entity
    end
  end

  def generate_line_link_token
    current_user.update!(line_link_token: SecureRandom.hex(8))
    redirect_to settings_path, notice: "LINE連携コードを発行しました。LINE公式アカウントに送ってください。"
  end

  def send_line_test
    if current_user.line_messaging_user_id.blank?
    redirect_to settings_path, alert: "LINE未連携です。先に連携コードで連携してください。"
    return
    end

  LinePushNotificationJob.perform_later(current_user.id, "テスト通知です")
  redirect_to settings_path, notice: "LINEにテスト通知を送信しました"
  rescue => e
    Rails.logger.error("[LINE_PUSH_TEST] #{e.class}: #{e.message}")
    redirect_to settings_path, alert: "送信に失敗しました（#{e.class}）。"
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
