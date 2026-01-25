require "rails_helper"

RSpec.describe DailyHabitRecord, type: :model do
  subject(:record) { build(:daily_habit_record) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:habit) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:habit) }
    it { is_expected.to validate_presence_of(:record_date) }

    it "同一ユーザーは同じ日・同じhabitのレコードを複数持てない" do
      user = create(:user)
      habit = create(:habit, user:)
      date = Date.current

      create(:daily_habit_record, user:, habit:, record_date: date)
      dup = build(:daily_habit_record, user:, habit:, record_date: date)

      expect(dup).to be_invalid
    end

    it "別ユーザーなら同じ日・同じhabit_idでも作れる（ユーザーが違うので別物）" do
      date = Date.current

      user1 = create(:user)
      habit1 = create(:habit, user: user1)

      user2 = create(:user)
      habit2 = create(:habit, user: user2)

      create(:daily_habit_record, user: user1, habit: habit1, record_date: date)
      another = build(:daily_habit_record, user: user2, habit: habit2, record_date: date)

      expect(another).to be_valid
    end
  end

  describe "scopes" do
    it ".for_date は指定日のレコードだけ返す" do
      user = create(:user)
      habit = create(:habit, user:)

      d1 = Date.current
      d2 = d1 - 1.day

      r1 = create(:daily_habit_record, user:, habit:, record_date: d1)
      r2 = create(:daily_habit_record, user:, habit:, record_date: d2)

      expect(DailyHabitRecord.for_date(d1)).to contain_exactly(r1)
      expect(DailyHabitRecord.for_date(d2)).to contain_exactly(r2)
    end

    it ".today は今日のレコードだけ返す" do
      user = create(:user)
      habit = create(:habit, user:)

      today = Date.current
      yesterday = today - 1.day

      r_today = create(:daily_habit_record, user:, habit:, record_date: today)
      _r_yesterday = create(:daily_habit_record, user:, habit:, record_date: yesterday)

      expect(DailyHabitRecord.today).to include(r_today)
      expect(DailyHabitRecord.today.pluck(:record_date).uniq).to eq([today])
    end

    it ".completed は完了だけ、.incomplete は未完了だけ返す" do
      user = create(:user)
      habit = create(:habit, user:)

      done = create(
        :daily_habit_record,
        user:,
        habit:,
        record_date: Date.current,
        is_completed: true,
        completed_at: Time.zone.now
      )

      todo = create(
        :daily_habit_record,
        user:,
        habit:,
        record_date: Date.current - 1.day, # ←ユニーク制約回避
        is_completed: false,
        completed_at: nil
      )

      expect(DailyHabitRecord.completed).to include(done)
      expect(DailyHabitRecord.completed).not_to include(todo)

      expect(DailyHabitRecord.incomplete).to include(todo)
      expect(DailyHabitRecord.incomplete).not_to include(done)
    end
  end

  describe "#completed?" do
    it "is_completed が true のとき true" do
      record = build(:daily_habit_record, is_completed: true)
      expect(record.completed?).to be true
    end

    it "is_completed が false のとき false" do
      record = build(:daily_habit_record, is_completed: false)
      expect(record.completed?).to be false
    end
  end

  describe "#toggle_completion!" do
    include ActiveSupport::Testing::TimeHelpers

    it "未完了→完了にすると is_completed=true かつ completed_at が入る" do
      travel_to(Time.zone.parse("2026-01-10 20:00:00")) do
        record = create(:daily_habit_record, is_completed: false, completed_at: nil)

        record.toggle_completion!

        record.reload
        expect(record.is_completed).to be true
        expect(record.completed_at).to eq(Time.zone.parse("2026-01-10 20:00:00"))
      end
    end

    it "完了→未完了にすると is_completed=false かつ completed_at が nil になる" do
      record = create(:daily_habit_record, is_completed: true, completed_at: Time.zone.now)

      record.toggle_completion!

      record.reload
      expect(record.is_completed).to be false
      expect(record.completed_at).to be_nil
    end
  end
end
