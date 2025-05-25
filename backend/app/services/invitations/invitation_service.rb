# frozen_string_literal: true

module Invitations
  class InvitationService < BaseService
    validate :organization_owner

    private

    def organization_owner
      return if organization_id.nil?
      return organization_does_not_exist if organization.nil?
      return if organization.owner_id == current_user.id

      errors.add(:organization, 'must be owned by the current user')
    end

    def organization
      @organization ||= Organization.find_by(id: organization_id)
    end

    def organization_id
      params[:organization_id]
    end

    def organization_does_not_exist
      errors.add(:organization, 'does not exist')
    end
  end
end
