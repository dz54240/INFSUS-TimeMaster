# frozen_string_literal: true

FactoryBot.define do
  factory :team_membership do
    association :user
    association :team
  end
end
