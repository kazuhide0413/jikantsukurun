class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :habits, dependent: :destroy
  has_many :daily_habit_records, through: :habits
  has_many :daily_sessions, dependent: :destroy

  validates :name, presence: true

  after_create :copy_default_habits

  private

  def copy_default_habits
    DefaultHabit.find_each do |template|
      habits.create!(
        title: template.title
      )
    end
  end
end
