# frozen_string_literal: true

# == Schema Information
#
# Table name: team_memberships
#
#  id         :bigint           not null, primary key
#  team_id    :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TeamMembership < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :team_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :team_id, message: 'is already a member of this team' }

  def self.serializer_includes
    [:user]
  end
end
