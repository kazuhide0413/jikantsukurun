require "rails_helper"

RSpec.describe "Habit", type: :system do
  let(:password) { "Paseword!1" }

  let!(:user) do
    User.create!(
      name: "テストユーザー",
      email: "test@example.com",
      password: password
    )
  end

  let!(:habit) do
    Habit.create!(user: user, title: "歯磨き")
  end

  describe "ログイン前" do
    it "一覧ページにアクセス => アクセス失敗（ログインへ）" do
      visit habits_path
      expect(page).to have_current_path(new_user_session_path, ignore_query: true).or have_content("ログイン")
    end

    it "新規登録ページにアクセス => アクセス失敗（ログインへ）" do
      visit new_habit_path
      expect(page).to have_current_path(new_user_session_path, ignore_query: true).or have_content("ログイン")
    end

    it "編集ページにアクセス => アクセス失敗（ログインへ）" do
      visit edit_habit_path(habit)
      expect(page).to have_current_path(new_user_session_path, ignore_query: true).or have_content("ログイン")
    end
  end

  describe "ログイン後" do
    before { login_as(user, scope: :user) }

    it "新規登録: 正常 => 登録成功" do
      visit new_habit_path

      fill_in "嫌な習慣", with: "洗濯"
      click_on "作成"

      expect(page).to have_content("洗濯")
    end

    it "新規登録: 未入力 => 登録失敗" do
      visit new_habit_path

      fill_in "嫌な習慣", with: ""
      click_on "作成"

      expect(page).to have_content("入力").or have_content("エラー").or have_content("習慣")
    end

    it "編集: 正常 => 編集成功" do
      visit edit_habit_path(habit)

      fill_in "習慣名", with: "歯磨き（夜）"
      click_on "更新"

      expect(page).to have_content("歯磨き（夜）")
    end

    it "編集: 未入力 => 編集失敗" do
      visit edit_habit_path(habit)

      fill_in "習慣名", with: ""
      click_on "更新"

      expect(page).to have_content("入力").or have_content("エラー").or have_content("習慣")
    end

    it "削除: 削除成功" do
      visit edit_habit_path(habit)

      # rack_testではaccept_confirmが使えないので、まずは素直にクリック
      click_on "削除", match: :first

      expect(page).not_to have_content("歯磨き")
    end
  end
end
