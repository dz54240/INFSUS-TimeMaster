# frozen_string_literal: true

class OrganizationSerializer
  include JSONAPI::Serializer

  set_type :organization
  set_id :id

  attributes :name
  attributes :description
  attributes :established_at
  attributes :owner_id
  attributes :created_at
  attributes :updated_at
end
