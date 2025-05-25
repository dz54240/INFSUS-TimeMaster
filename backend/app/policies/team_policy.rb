# frozen_string_literal: true

class TeamPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    organization_owner? || member_of_team?
  end

  def create?
    user.role == 'owner'
  end

  def update?
    organization_owner?
  end

  def destroy?
    organization_owner?
  end

  def permitted_attributes_for_create
    [:name, :description, :organization_id]
  end

  def permitted_attributes_for_update
    [:name, :description]
  end

  private

  def organization_owner?
    record.organization.owner_id == user.id
  end

  def member_of_team?
    record.users.exists?(id: user.id)
  end

  class Scope < Scope
    def resolve
      if user.role == 'owner'
        scope.where(organization_id: user.owned_organizations.pluck(:id))
      else
        scope.where(id: user.teams.pluck(:id))
      end
    end
  end
end
