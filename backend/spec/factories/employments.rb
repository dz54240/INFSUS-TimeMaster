# frozen_string_literal: true

FactoryBot.define do
  factory :employment do
    association :user
    association :organization
  end
end
