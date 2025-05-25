# frozen_string_literal: true

module Projects
  class ProjectService < BaseService
    validate :organization_owner

    private

    def organization_owner
      return if organization_id.nil?
      return if organization_scope.exists?(organization_id)

      errors.add(:organization, 'is not accessible')
    end

    def organization_id
      params[:organization_id]
    end

    def organization_scope
      OrganizationPolicy::Scope.new(current_user, Organization).resolve
    end
  end
end
