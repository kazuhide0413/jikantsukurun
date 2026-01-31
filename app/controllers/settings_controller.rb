class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_line_login, only: [:edit_line_notify, :update_line_notify]

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

  def edit_line_notify
    @user = current_user
    # 初期値がnilの人がいてもUIで扱えるように
    @user.line_notify_time ||= Time.zone.parse("12:00")
  end

  def update_line_notify
    @user = current_user

    if @user.update(line_notify_params)
      redirect_to settings_path, notice: "LINE通知設定を更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit_line_notify, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def line_notify_params
    params.require(:user).permit(:line_notify_enabled, :line_notify_time)
  end

  def require_line_login
    unless current_user.provider == "line_v2_1" && current_user.line_messaging_user_id.present?
      redirect_to settings_path, alert: "LINEログインしたユーザーのみ通知設定が可能です"
    end
  end
end
