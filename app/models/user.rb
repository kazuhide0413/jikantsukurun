class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :line_v2_1]

  has_many :habits, dependent: :destroy
  has_many :daily_habit_records, through: :habits
  has_many :daily_sessions, dependent: :destroy

  validates :name, presence: true
  validates :uid, uniqueness: { scope: :provider }, if: -> { uid.present? }

  after_create :copy_default_habits

  def self.from_omniauth(auth)
    provider = auth.provider
    uid      = auth.uid
    email    = auth.info.email&.downcase

    raise "Email not provided by OAuth provider" if email.blank?

    # ① provider + uid で既に紐付いているユーザー
    user = find_by(provider: provider, uid: uid)
    return user if user.present?

    # ② email が同じ既存ユーザーがいれば紐付ける
    user = find_by(email: email)
    if user.present?
      user.update!(
        provider: provider,
        uid: uid,
        name: user.name.presence || auth.info.name.presence || email,
        avatar_url: (auth.info.image if user.respond_to?(:avatar_url) && auth.info.image)
      )
      return user
    end

    # ③ 完全に新規ユーザー
    create!(
      provider: provider,
      uid: uid,
      email: email,
      name: auth.info.name.presence || email,
      password: Devise.friendly_token[0, 20],
      avatar_url: (auth.info.image if respond_to?(:avatar_url) && auth.info.image)
    )
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  private

  def copy_default_habits
    DefaultHabit.find_each do |template|
      habits.create!(title: template.title)
    end
  end
end
