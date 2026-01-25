require "rails_helper"

RSpec.describe DailySession, type: :model do
  subject(:daily_session) { build(:daily_session) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:session_date) }

    # belongs_to :user は Rails のデフォルトで required 扱い（optional: true じゃない限り）
    it { is_expected.to validate_presence_of(:user) }

    it "同一ユーザーは同じsession_dateを2つ持てない" do
      user = create(:user)
      date = Date.current

      create(:daily_session, user:, session_date: date)
      dup = build(:daily_session, user:, session_date: date)

      expect(dup).to be_invalid
    end
  end

  describe "#can_record_habits?" do
    it "帰宅時刻があり、就寝時刻がないと true" do
      session = build(:daily_session, return_home_at: Time.zone.now, bedtime_at: nil)
      expect(session.can_record_habits?).to be true
    end

    it "帰宅時刻がないと false" do
      session = build(:daily_session, return_home_at: nil, bedtime_at: nil)
      expect(session.can_record_habits?).to be false
    end

    it "就寝時刻があると false" do
      session = build(:daily_session, return_home_at: Time.zone.now, bedtime_at: Time.zone.now)
      expect(session.can_record_habits?).to be false
    end
  end

  describe "#formatted_effective_duration" do
    it "effective_duration が nil なら nil" do
      session = build(:daily_session, effective_duration: nil)
      expect(session.formatted_effective_duration).to be_nil
    end

    it "秒を「◯時間◯分」に変換する" do
      session = build(:daily_session, effective_duration: (2 * 3600 + 15 * 60)) # 2h15m
      expect(session.formatted_effective_duration).to eq "2時間15分"
    end
  end

  describe "#all_habits_completed_today?" do
    it "target_habit_ids が全て完了済みなら true" do
      user = create(:user)
      date = Date.current

      h1 = create(:habit, user:, title: "炊事")
      h2 = create(:habit, user:, title: "洗濯")

      create(:daily_habit_record,
        user:,
        habit: h1,
        record_date: date,
        is_completed: true,
        completed_at: Time.zone.now
      )
      create(:daily_habit_record,
        user:,
        habit: h2,
        record_date: date,
        is_completed: true,
        completed_at: Time.zone.now
      )

      session = create(:daily_session, user:, session_date: date)

      expect(session.all_habits_completed_today?([h1.id, h2.id])).to be true
    end

    it "1つでも未完了があれば false" do
      user = create(:user)
      date = Date.current

      h1 = create(:habit, user:, title: "炊事")
      h2 = create(:habit, user:, title: "洗濯")

      create(:daily_habit_record,
        user:,
        habit: h1,
        record_date: date,
        is_completed: true,
        completed_at: Time.zone.now
      )
      # h2 は未完了（recordなし or is_completed false）

      session = create(:daily_session, user:, session_date: date)

      expect(session.all_habits_completed_today?([h1.id, h2.id])).to be false
    end
  end

  describe "#calculate_effective_duration!" do
    it "最後の完了時刻がない、または bedtime_at がない場合は effective_duration を 0 にして返す" do
      user = create(:user)
      date = Date.current
      session = create(:daily_session, user:, session_date: date, bedtime_at: nil)

      expect(session.calculate_effective_duration!).to eq 0
      expect(session.reload.effective_duration).to eq 0
    end

    it "bedtime_at - 最後の完了時刻（completed_at）の秒数を保存して返す" do
      user = create(:user)
      date = Date.current

      session = create(
        :daily_session,
        user:,
        session_date: date,
        bedtime_at: Time.zone.parse("#{date} 23:30:00")
      )

      h1 = create(:habit, user:, title: "炊事")
      h2 = create(:habit, user:, title: "洗濯")

      create(:daily_habit_record,
        user:,
        habit: h1,
        record_date: date,
        is_completed: true,
        completed_at: Time.zone.parse("#{date} 22:00:00")
      )
      create(:daily_habit_record,
        user:,
        habit: h2,
        record_date: date,
        is_completed: true,
        completed_at: Time.zone.parse("#{date} 23:00:00") # ←最後
      )

      # 23:30 - 23:00 = 30分 = 1800秒
      expect(session.calculate_effective_duration!).to eq 1800
      expect(session.reload.effective_duration).to eq 1800
    end
  end

  describe ".logical_today" do
    include ActiveSupport::Testing::TimeHelpers

    it "深夜0〜3時台は前日扱い（cutoff_hour=4）" do
      travel_to(Time.zone.parse("2026-01-10 03:59:00")) do
        expect(DailySession.logical_today).to eq Date.parse("2026-01-09")
      end
    end

    it "4時以降は当日扱い（cutoff_hour=4）" do
      travel_to(Time.zone.parse("2026-01-10 04:00:00")) do
        expect(DailySession.logical_today).to eq Date.parse("2026-01-10")
      end
    end

    it "cutoff_hour を変えられる" do
      travel_to(Time.zone.parse("2026-01-10 05:59:00")) do
        expect(DailySession.logical_today(6)).to eq Date.parse("2026-01-09")
      end
    end
  end
end
