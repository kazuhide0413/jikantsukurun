class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :habits, dependent: :destroy
  has_many :daily_habit_records, through: :habits
  has_many :daily_sessions, dependent: :destroy

  validates :name, presence: true
  validates :uid, uniqueness: { scope: :provider }, if: -> { uid.present? }

  after_create :copy_default_habits

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name.presence || auth.info.email
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.avatar_url = auth.info.image if user.respond_to?(:avatar_url) && auth.info.image
    end
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
