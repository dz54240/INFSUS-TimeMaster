# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  set_type :user
  set_id :id

  attributes :email
  attributes :first_name
  attributes :last_name
  attributes :email
  attributes :role
  attributes :hourly_rate
  attributes :created_at
  attributes :updated_at
end
