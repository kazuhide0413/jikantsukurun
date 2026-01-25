require "rails_helper"

RSpec.describe Habit, type: :model do
  subject(:habit) { build(:habit) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:daily_habit_records).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }

    it "同一ユーザー内で title は一意（重複不可）" do
      user = create(:user)
      create(:habit, user:, title: "炊事")
      dup = build(:habit, user:, title: "炊事")

      expect(dup).to be_invalid
      expect(dup.errors[:title]).to include("はすでに登録されています")
    end

    it "別ユーザーなら同じ title でも登録できる" do
      user1 = create(:user)
      user2 = create(:user)

      create(:habit, user: user1, title: "炊事")
      another = build(:habit, user: user2, title: "炊事")

      expect(another).to be_valid
    end
  end
end
