# frozen_string_literal: true

# == Schema Information
#
# Table name: employments
#
#  id              :bigint           not null, primary key
#  user_id         :bigint           not null
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Employment < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :organization_id, presence: true
  validates :user_id, uniqueness: { scope: :organization_id, message: 'is already employed by this organization' }

  def self.serializer_includes
    [:user]
  end
end
