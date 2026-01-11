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

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
