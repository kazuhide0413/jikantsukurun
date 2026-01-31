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
end
