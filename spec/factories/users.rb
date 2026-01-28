FactoryBot.define do
  factory :user do
    name { "テスト太郎" }
    sequence(:email) { |n| "test#{n}@example.com" }

    # 複雑性: 小文字/数字/記号を含む + 同一文字連続なし（例: aa, 11, !! を避ける）
    password { "ab1!cd2@" }

    trait :google do
      provider { "google_oauth2" }
      sequence(:uid) { |n| "google-uid-#{n}" }
    end

    trait :line do
      provider { "line_v2_1" }
      sequence(:uid) { |n| "line-uid-#{n}" }
    end
  end
end
