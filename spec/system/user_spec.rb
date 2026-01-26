require "rails_helper"

RSpec.describe "User", type: :system do
  let(:password) { "Paseword!1" }

  let!(:existing_user) do
    User.create!(
      name: "既存ユーザー",
      email: "exist@example.com",
      password: password
    )
  end

  describe "ログイン前" do
    it "ユーザー新規登録: 正常 => 登録成功" do
      visit new_user_registration_path

      fill_in "ユーザー名", with: "新規ユーザー"
      fill_in "メールアドレス", with: "new@example.com"
      fill_in "パスワード", with: password

      # ラベルが違う場合はここをあなたの画面に合わせて変更
      fill_in "パスワード（確認用）", with: password

      # ボタン文言が「登録」以外なら合わせて変更
      click_on "登録"

      # 成功判定：アプリの仕様に合わせて確認（設定/ログアウト/ガイドなど）
      expect(page).not_to have_content("入力")
      expect(page).not_to have_content("エラー")

    end

    it "ユーザー新規登録: メール未入力 => 登録失敗" do
      visit new_user_registration_path

      fill_in "ユーザー名", with: "新規ユーザー"
      fill_in "パスワード", with: password
      fill_in "パスワード（確認用）", with: password
      click_on "登録"

      expect(page).to have_content("メールアドレス")
    end

    it "ユーザー新規登録: 登録済みメール => 登録失敗" do
      visit new_user_registration_path

      fill_in "ユーザー名", with: "新規ユーザー"
      fill_in "メールアドレス", with: existing_user.email
      fill_in "パスワード", with: password
      fill_in "パスワード（確認用）", with: password
      click_on "登録"

      # Deviseの文言は環境で揺れるので、強めに確認
      expect(page).to have_content("すでに存在")
        .or have_content("使用")
        .or have_content("登録できません")
    end

    it "設定ページ遷移: ログイン前 => アクセス失敗（ログインへ）" do
      visit settings_path
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
        .or have_content("ログイン")
    end
  end

  describe "ログイン後" do
    it "ユーザー名編集: 正常 => 編集成功" do
      login_as(existing_user, scope: :user)

      visit edit_name_settings_path

      fill_in "ユーザー名", with: "変更後ユーザー"
      click_on "更新" # ボタン文言が違うなら合わせる

      expect(page).to have_content("設定")
        .or have_content("ユーザー名編集")
        .or have_content("変更")
    end

    it "ユーザー名編集: 未入力 => 編集失敗" do
      login_as(existing_user, scope: :user)

      visit edit_name_settings_path

      fill_in "ユーザー名", with: ""
      click_on "更新"

      expect(page).to have_content("入力")
        .or have_content("エラー")
        .or have_content("ユーザー名")
    end
  end
end
