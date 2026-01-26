require "rails_helper"
require "warden/test/helpers"

RSpec.describe "UserSession", type: :system do
  let(:password) { "Paseword!1" }

  let!(:user) do
    User.create!(
      name: "テストユーザー",
      email: "test@example.com",
      password: password
    )
  end

  describe "ログイン前" do
    it "フォームの入力値が正常 => ログイン成功" do
      visit new_user_session_path

      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: password
      click_on "ログイン"

      # ログインできていればエラーメッセージは表示されない
      expect(page).not_to have_content("メールアドレス もしくはパスワードが不正です。")
    end

    it "フォーム未入力 => ログイン失敗" do
      visit new_user_session_path

      click_on "ログイン"

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  describe "ログイン後" do
    it "ログアウトボタンを押す => ログアウトされる", js: true do
      login_as(user, scope: :user)

      visit settings_path
      click_on "ログアウト"

      expect(page).to have_current_path(root_path, ignore_query: true)
      expect(page).to have_content("ログイン")
    end
  end
end
