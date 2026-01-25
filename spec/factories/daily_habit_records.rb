FactoryBot.define do
  factory :daily_habit_record do
    association :user
    record_date { Date.current }
    is_completed { false }
    completed_at { nil }

    habit { association :habit, user: user }
  end
end
