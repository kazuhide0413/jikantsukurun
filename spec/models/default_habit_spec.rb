require "rails_helper"

RSpec.describe DefaultHabit, type: :model do
  subject(:default_habit) { build(:default_habit) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }

    it "title が同じものは登録できない" do
      create(:default_habit, title: "cook")
      dup = build(:default_habit, title: "cook")

      expect(dup).to be_invalid
    end
  end
end
