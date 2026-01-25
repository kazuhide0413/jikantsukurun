FactoryBot.define do
  factory :default_habit do
    sequence(:title) { |n| "デフォ習慣#{n}" }
  end
end
