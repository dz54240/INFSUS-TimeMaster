# frozen_string_literal: true

class TeamMembershipSerializer
  include JSONAPI::Serializer

  set_type :team_membership
  set_id :id

  attribute :created_at
  attribute :updated_at

  belongs_to :user, serializer: UserSerializer
end
