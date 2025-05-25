# frozen_string_literal: true

# == Schema Information
#
# Table name: sessions
#
#  id         :bigint           not null, primary key
#  token      :string
#  user_id    :bigint           not null
#  expired_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Session < ApplicationRecord
  has_secure_token

  belongs_to :user

  validates :token, presence: true, uniqueness: true
  validates :user_id, presence: true
end
