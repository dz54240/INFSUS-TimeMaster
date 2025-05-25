# frozen_string_literal: true

# == Schema Information
#
# Table name: work_logs
#
#  id            :bigint           not null, primary key
#  start_time    :datetime         not null
#  end_time      :datetime         not null
#  activity_type :string           not null
#  description   :text
#  cost          :decimal(10, 2)
#  user_id       :bigint           not null
#  project_id    :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class WorkLog < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :user_id, presence: true
  validates :project_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :activity_type, presence: true, inclusion: { in: %w[on_site remote_work] }
  validate :end_time_after_start_time
  validate :work_time_in_range

  def self.serializer_includes
    [:user, :project]
  end

  private

  def end_time_after_start_time
    return unless end_time <= start_time

    errors.add(:end_time, 'must be after start time')
  end

  def work_time_in_range
    return if work_time.between?(0, 24)

    errors.add(:work_time, 'must be between 0 and 24 hours')
  end

  def work_time
    return 0 unless start_time && end_time

    (end_time.to_time - start_time.to_time) / 3600.0
  end
end
