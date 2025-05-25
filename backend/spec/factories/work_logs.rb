# frozen_string_literal: true

FactoryBot.define do
  factory :work_log do
    association :user
    association :project
    start_time { Time.zone.now }
    end_time { Time.zone.now + 1.hour }
    description { 'test description' }
    cost { user.hourly_rate * (end_time - start_time).to_i / 3600.0 }
  end
end
