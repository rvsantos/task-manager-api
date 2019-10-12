FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 123456 }
    password_confirmation { 123456 }

    trait :without_email do
      email { 'invalid_email@' }
    end

    trait :without_password do
      password nil
    end

    factory :user_invalid_email, traits: [:without_email]
    factory :user_without_password, traits: [:without_password]
  end
end
