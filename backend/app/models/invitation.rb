# frozen_string_literal: true

# == Schema Information
#
# Table name: invitations
#
#  id              :bigint           not null, primary key
#  token           :string
#  token_used      :boolean          default(FALSE), not null
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Invitation < ApplicationRecord
  has_secure_token

  belongs_to :organization

  default_scope { where(token_used: false) }

  validates :token, presence: true, uniqueness: true
  validates :token_used, inclusion: { in: [true, false] }
  validates :organization_id, presence: true
end
