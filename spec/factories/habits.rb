FactoryBot.define do
  factory :habit do
    association :user
    title { "歯みがき" }
  end
end
