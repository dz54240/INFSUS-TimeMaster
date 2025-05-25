# frozen_string_literal: true

module Teams
  class TeamService < BaseService
    validate :organization_accessible

    private

    def organization_accessible
      return if organization_id.nil?
      return if organization_scope.exists?(id: organization_id)

      errors.add(:organization, 'must be accessible')
    end

    def organization_id
      params[:organization_id]
    end

    def organization_scope
      OrganizationPolicy::Scope.new(current_user, Organization).resolve
    end
  end
end
