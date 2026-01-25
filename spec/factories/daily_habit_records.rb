FactoryBot.define do
  factory :daily_habit_record do
    association :user
    association :habit
    record_date { Date.current }
    is_completed { false }
    completed_at { nil }
  end
end
