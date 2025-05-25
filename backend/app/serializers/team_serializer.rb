# frozen_string_literal: true

class TeamSerializer
  include JSONAPI::Serializer

  set_type :team
  set_id :id

  attributes :name
  attributes :description
  attributes :organization_id
  attributes :created_at
  attributes :updated_at
end
