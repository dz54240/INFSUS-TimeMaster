# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    description { 'test description' }
    association :organization

    trait :with_members do
      after(:create) do |team|
        create_list(:team_membership, 3, team:)
      end
    end
  end
end
