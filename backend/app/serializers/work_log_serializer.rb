# frozen_string_literal: true

class WorkLogSerializer
  include JSONAPI::Serializer

  set_type :work_log
  set_id :id

  attribute :start_time
  attribute :end_time
  attribute :activity_type
  attribute :description
  attribute :cost
  attribute :created_at
  attribute :updated_at

  belongs_to :user, serializer: UserSerializer
  belongs_to :project, serializer: ProjectSerializer
end
