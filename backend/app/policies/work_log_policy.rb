# frozen_string_literal: true

class WorkLogPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    organization_owner? || owner?
  end

  def create?
    user.role == 'employee'
  end

  def update?
    organization_owner? || owner?
  end

  def destroy?
    organization_owner? || owner?
  end

  def permitted_attributes_for_create
    [:start_time, :end_time, :activity_type, :description, :project_id]
  end

  def permitted_attributes_for_update
    [:start_time, :end_time, :activity_type, :description]
  end

  private

  def organization_owner?
    record.project.organization.owner_id == user.id
  end

  def owner?
    record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      if user.role == 'owner'
        scope.joins(project: :organization).where(organizations: { owner_id: user.id })
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
