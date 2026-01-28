FactoryBot.define do
  factory :daily_session do
    association :user
    session_date { Date.current }
    return_home_at { Time.zone.now.change(hour: 18, min: 0) }
    bedtime_at     { Time.zone.now.change(hour: 23, min: 30) }
    effective_duration { 0 }
  end
end
