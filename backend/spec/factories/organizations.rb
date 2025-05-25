# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organization #{n}" }
    description { 'test description' }
    established_at { Date.new(2020, 1, 1) }
    association :owner, factory: :user, role: 'owner'

    trait :with_employees do
      after(:create) do |organization|
        create_list(:employment, 3, organization:)
      end
    end

    trait :with_projects do
      after(:create) do |organization|
        create_list(:project, 2, organization:)
      end
    end

    trait :with_teams do
      after(:create) do |organization|
        create_list(:team, 2, organization:)
      end
    end
  end
end
