# frozen_string_literal: true

class TeamMembershipPolicy < ApplicationPolicy
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
    false
  end

  def destroy?
    organization_owner?
  end

  def permitted_attributes_for_create
    [:user_id, :team_id]
  end

  def permitted_attributes_for_update
    []
  end

  private

  def organization_owner?
    record.team.organization.owner_id == user.id
  end

  def member_of_team?
    record.team.users.exists?(id: user.id)
  end

  class Scope < Scope
    def resolve
      if user.role == 'owner'
        scope.joins(team: :organization).where(organizations: { owner_id: user.id })
      else
        scope.joins(:team).where(teams: { id: user.teams.pluck(:id) })
      end
    end
  end
end
