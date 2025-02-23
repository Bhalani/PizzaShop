FactoryBot.define do
  factory :user do
    email { "vendor@example.com" }
    password { "password" }
    password_confirmation { "password" }

    trait :vendor do
      role { "vendor" }
    end

    trait :customer do
      role { "customer" }
    end
  end
end
