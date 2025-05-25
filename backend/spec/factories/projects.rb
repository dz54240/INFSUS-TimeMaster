# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { 'test description' }
    start_date { Date.new(2020, 1, 1) }
    end_date { nil }
    association :organization
    budget_amount { 1000 }

    trait :completed do
      end_date { Date.current }
    end

    trait :with_work_logs do
      after(:create) do |project|
        create_list(:work_log, 3, project:)
      end
    end
  end
end
