# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    association :user
    expired_at { 24.hours.from_now }

    trait :expired do
      expired_at { 1.hour.ago }
    end
  end
end
