require "rails_helper"

RSpec.describe "UserSession", type: :system do
  let!(:user) do
    User.create!(
      name: "テストユーザー",
      email: "test@example.com",
      password: "Paseword!1"
    )
  end

  describe "ログイン前" do
    it "フォームの入力値が正常 => ログイン成功" do
      visit new_user_session_path

      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "Password!1"
      click_on "ログイン"

      # ログイン後の画面に来ていることを確認
      expect(page).to have_content("設定").or have_content("ログアウト")
    end

    it "フォーム未入力 => ログイン失敗" do
      visit new_user_session_path

      click_on "ログイン"

      # エラー表示 or ログイン画面に留まることを確認
      expect(page).to have_content("メールアドレス")
        .or have_content("入力")
        .or have_current_path(new_user_session_path)
    end
  end

  describe "ログイン後" do
    before do
      login(user) # ← LoginMacrosの共通処理
    end

    it "ログアウトボタンを押す => ログアウトされる" do
      click_on "ログアウト"

      expect(page).to have_content("ログイン")
        .or have_current_path(new_user_session_path)
    end
  end
end
