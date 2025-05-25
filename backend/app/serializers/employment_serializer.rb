# frozen_string_literal: true

class EmploymentSerializer
  include JSONAPI::Serializer

  set_type :employment
  set_id :id

  attribute :organization_id
  attribute :user_id
  attribute :created_at
  attribute :updated_at

  belongs_to :user, serializer: UserSerializer
end
