# frozen_string_literal: true

class InvitationSerializer
  include JSONAPI::Serializer

  set_type :invitation
  set_id :id

  attribute :token
  attribute :token_used
  attribute :organization_id
  attribute :created_at
  attribute :updated_at
end
