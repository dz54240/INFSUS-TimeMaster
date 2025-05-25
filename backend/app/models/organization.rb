# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  description    :text
#  established_at :date
#  owner_id       :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Organization < ApplicationRecord
  belongs_to :owner, class_name: 'User', inverse_of: :owned_organizations

  has_many :employments, dependent: :destroy
  has_many :users, through: :employments
  has_many :projects, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :invitations, dependent: :destroy

  validates :name, presence: true
  validates :owner_id, presence: true
  validate :established_at_not_in_future

  private

  def established_at_not_in_future
    return unless established_at.present? && established_at > Date.current

    errors.add(:established_at, 'cannot be in the future')
  end
end
