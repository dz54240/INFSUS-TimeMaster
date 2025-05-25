# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string           not null
#  role            :string           not null
#  password_digest :text
#  birth_date      :date
#  hourly_rate     :decimal(10, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_secure_password

  has_many :employments, dependent: :destroy
  has_many :work_logs, dependent: :destroy
  has_many :work_logs, dependent: :destroy
  has_many :projects, through: :work_logs
  has_many :organizations, through: :employments
  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :sessions, dependent: :destroy
  has_many :owned_organizations, class_name: 'Organization', foreign_key: 'owner_id', dependent: :destroy, inverse_of: :owner

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_email_format_of :email, message: 'is invalid'
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :role, presence: true, inclusion: { in: %w[owner employee] }
  validates :hourly_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :birth_date_not_in_future

  private

  def birth_date_not_in_future
    return unless birth_date.present? && birth_date > Date.current

    errors.add(:birth_date, "can't be in the future")
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
