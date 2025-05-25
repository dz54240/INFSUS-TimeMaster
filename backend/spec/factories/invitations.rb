# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    association :organization
    token { SecureRandom.hex(20) }
    token_used { false }

    trait :used do
      token_used { true }
    end
  end
end
