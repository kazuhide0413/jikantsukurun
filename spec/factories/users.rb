FactoryBot.define do
  factory :user do
    name { "テスト太郎" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "Abcdef1!" } # 8文字以上、英数記号
  end
end
