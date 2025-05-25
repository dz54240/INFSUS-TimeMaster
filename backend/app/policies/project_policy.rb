# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    organization_owner? || organization_employee?
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
    [:name, :description, :organization_id, :start_date, :end_date, :budget_amount]
  end

  def permitted_attributes_for_update
    [:name, :description, :start_date, :end_date, :budget_amount]
  end

  private

  def organization_owner?
    record.organization.owner_id == user.id
  end

  def organization_employee?
    record.organization.users.exists?(id: user.id)
  end

  class Scope < Scope
    def resolve
      if user.role == 'owner'
        scope.where(organization_id: user.owned_organizations.pluck(:id))
      else
        # da vidi samo projekte na koje je bookirao work log
        # ovo ne moze jer inace nece moc uopce kreirat work log na projektu na kojem nije bookirao
        scope.where(organization_id: user.organizations.pluck(:id))
      end
    end
  end
end
