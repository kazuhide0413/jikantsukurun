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

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
