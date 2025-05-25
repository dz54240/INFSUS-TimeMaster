# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  description     :text
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Team < ApplicationRecord
  belongs_to :organization

  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships

  validates :name, presence: true
  validates :organization_id, presence: true
end
