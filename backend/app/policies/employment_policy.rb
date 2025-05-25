# frozen_string_literal: true

class EmploymentPolicy < ApplicationPolicy
  def index?
    user.role == 'owner'
  end

  def show?
    organization_owner?
  end

  def create?
    user.role == 'employee'
  end

  def update?
    false
  end

  def destroy?
    organization_owner?
  end

  def permitted_attributes_for_create
    [:organization_token]
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
