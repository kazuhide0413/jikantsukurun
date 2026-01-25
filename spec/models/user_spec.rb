require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "associations" do
    it { is_expected.to have_many(:habits).dependent(:destroy) }
    it { is_expected.to have_many(:daily_sessions).dependent(:destroy) }

    # through :habits の関連は shoulda で書けないことがあるので、ここは挙動で軽く確認
    it "daily_habit_records を参照できる" do
      u = create(:user)
      habit = create(:habit, user: u)
      create(:daily_habit_record, user: u, habit:, record_date: Date.current)

      expect(u.daily_habit_records.count).to eq 1
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    # Deviseのvalidatableが email presence/uniqueness を持っている前提
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it "uid がある場合、provider + uid は一意" do
      create(:user, provider: "google_oauth2", uid: "abc123", email: "a@example.com", password: "ab1!cd2@")
      dup = build(:user, provider: "google_oauth2", uid: "abc123", email: "b@example.com", password: "ab1!cd2@")

      expect(dup).to be_invalid
    end

    it "uid が空なら provider + uid の一意バリデーションは走らない" do
      u = build(:user, provider: "google_oauth2", uid: nil)
      expect(u).to be_valid
    end
  end

  describe "password_complexity" do
    it "小文字を含まないと無効" do
      u = build(:user, password: "AB1!CD2@")
      expect(u).to be_invalid
      expect(u.errors[:password]).to include("は英小文字を含めてください")
    end

    it "数字を含まないと無効" do
      u = build(:user, password: "ab!!cd@@")
      expect(u).to be_invalid
      expect(u.errors[:password]).to include("は数字を含めてください")
    end

    it "記号を含まないと無効" do
      u = build(:user, password: "ab12cd34")
      expect(u).to be_invalid
      expect(u.errors[:password]).to include("は記号を含めてください")
    end

    it "同じ文字の連続があると無効" do
      u = build(:user, password: "ab11!cd2")
      expect(u).to be_invalid
      expect(u.errors[:password]).to include("は同じ文字を連続して使用できません")
    end

    it "条件を満たせば有効" do
      u = build(:user, password: "ab1!cd2@")
      expect(u).to be_valid
    end
  end

  describe "after_create :copy_default_habits" do
    it "DefaultHabit を作っておくと、ユーザー作成時に habits にコピーされる" do
      DefaultHabit.create!(title: "炊事")
      DefaultHabit.create!(title: "洗濯")

      u = create(:user)

      expect(u.habits.pluck(:title)).to include("炊事", "洗濯")
    end
  end

  describe ".from_omniauth" do
    # after_create :copy_default_habits の副作用を最小化（必要なら）
    before do
      DefaultHabit.delete_all
    end

    # Devise.friendly_token が password_complexity に引っかからないよう固定
    before do
      allow(Devise).to receive(:friendly_token).and_return("ab1!cd2@ef3#gh4$ij5%")
    end

    def build_auth(provider:, uid:, email:, name: "OAuth太郎", image: "https://example.com/avatar.png")
      OmniAuth::AuthHash.new(
        provider: provider,
        uid: uid,
        info: {
          email: email,
          name: name,
          image: image
        }
      )
    end

    it "provider + uid で既に紐付いているユーザーがいればそれを返す（更新しない）" do
      user = create(
        :user,
        provider: "google_oauth2",
        uid: "uid-123",
        email: "exist@example.com",
        name: "既存ユーザー"
      )

      auth = build_auth(provider: "google_oauth2", uid: "uid-123", email: "other@example.com", name: "別名")

      result = described_class.from_omniauth(auth)

      expect(result.id).to eq user.id
      expect(result.email).to eq "exist@example.com"
      expect(result.name).to eq "既存ユーザー"
    end

    it "email が同じ既存ユーザーがいれば provider/uid を紐付けて返す" do
      user = create(
        :user,
        provider: nil,
        uid: nil,
        email: "same@example.com",
        name: "元の名前"
      )

      auth = build_auth(
        provider: "line_v2_1",
        uid: "line-999",
        email: "same@example.com",
        name: "LINE太郎",
        image: "https://img.example.com/a.png"
      )

      result = described_class.from_omniauth(auth)

      user.reload
      expect(result.id).to eq user.id
      expect(user.provider).to eq "line_v2_1"
      expect(user.uid).to eq "line-999"
      expect(user.name).to eq "元の名前" # 既にあるので上書きされない想定
    end

    it "email が同じ既存ユーザーがいても name が既にある場合は name を上書きしない" do
      user = create(
        :user,
        provider: nil,
        uid: nil,
        email: "same2@example.com",
        name: "元の名前"
      )

      auth = build_auth(provider: "google_oauth2", uid: "g-777", email: "same2@example.com", name: "OAuthで来た名前")

      result = described_class.from_omniauth(auth)

      user.reload
      expect(result.id).to eq user.id
      expect(user.provider).to eq "google_oauth2"
      expect(user.uid).to eq "g-777"
      expect(user.name).to eq "元の名前" # ←上書きされない
    end

    it "該当がなければ新規ユーザーを作成して返す" do
      auth = build_auth(provider: "google_oauth2", uid: "new-uid", email: "new@example.com", name: "新規太郎")

      expect { described_class.from_omniauth(auth) }.to change(User, :count).by(1)

      created = User.find_by(email: "new@example.com")
      expect(created).to be_present
      expect(created.provider).to eq "google_oauth2"
      expect(created.uid).to eq "new-uid"
      expect(created.name).to eq "新規太郎"
      expect(created.avatar_url).to eq "https://example.com/avatar.png"
    end

    it "email が空なら例外を投げる" do
      auth = build_auth(provider: "google_oauth2", uid: "uid-x", email: nil)

      expect { described_class.from_omniauth(auth) }.to raise_error(RuntimeError, "Email not provided by OAuth provider")
    end
  end
end
