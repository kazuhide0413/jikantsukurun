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

  def line_notification
    @user = current_user
  end

  def enable_line_notification
    current_user.update!(line_notify_enabled: true)
    redirect_to line_notification_settings_path, notice: "LINE通知をONにしました"
  end

  def disable_line_notification
    current_user.update!(line_notify_enabled: false)
    redirect_to line_notification_settings_path, notice: "LINE通知をOFFにしました"
  end

  def generate_line_link_token
    token = SecureRandom.alphanumeric(8).upcase

    current_user.update!(
      line_link_token: token,
      line_link_token_generated_at: Time.zone.now
    )

    redirect_to line_notification_settings_path, notice: "LINEで連携コードを送ってください：#{token}"
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
