# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    first_name { 'John' }
    last_name { 'Doe' }
    role { 'employee' }
    hourly_rate { 100 }
    birth_date { Date.new(1990, 1, 1) }

    trait :owner do
      role { 'owner' }
    end

    trait :with_organization do
      after(:create) do |user|
        create(:organization, owner: user)
      end
    end

    trait :with_employment do
      after(:create) do |user|
        create(:employment, user:)
      end
    end
  end
end
