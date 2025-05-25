# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  description     :text
#  start_date      :date
#  end_date        :date
#  budget_amount   :decimal(10, 2)
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Project < ApplicationRecord
  belongs_to :organization

  has_many :work_logs, dependent: :destroy
  has_many :users, through: :work_logs

  validates :name, presence: true
  validates :organization_id, presence: true

  def current_cost
    work_logs.sum(:cost)
  end

  def total_hours_spent
    work_logs.sum do |work_log|
      (work_log.end_time.to_time - work_log.start_time.to_time) / 3600.0
    end
  end
end
