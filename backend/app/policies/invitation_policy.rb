# frozen_string_literal: true

class InvitationPolicy < ApplicationPolicy
  def index?
    user.role == 'owner'
  end

  def show?
    organization_owner?
  end

  def create?
    user.role == 'owner'
  end

  def update?
    false
  end

  def destroy?
    organization_owner?
  end

  def permitted_attributes_for_create
    [:organization_id]
  end

  private

  def organization_owner?
    record.organization.owner_id == user.id
  end

  class Scope < Scope
    def resolve
      scope.where(organization_id: user.owned_organizations.pluck(:id))
    end
  end
end
