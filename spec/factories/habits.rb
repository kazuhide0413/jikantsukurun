FactoryBot.define do
  factory :habit do
    association :user
    sequence(:title) { |n| "習慣#{n}" }
  end
end
