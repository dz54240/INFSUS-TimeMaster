# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    owned? || user_is_owner_of_organization?
  end

  def create?
    true
  end

  def update?
    owned? || user_is_owner_of_organization?
  end

  def destroy?
    owned?
  end

  def permitted_attributes_for_create
    [:first_name, :last_name, :email, :password, :birth_date, :role]
  end

  def permitted_attributes_for_update
    if user.role == 'owner' && record.id != user.id
      [:hourly_rate]
    elsif user.role == 'owner' && record.id == user.id
      [:first_name, :last_name, :email, :birth_date, :hourly_rate]
    else
      [:first_name, :last_name, :email, :birth_date]
    end
  end

  private

  def owned?
    record.id == user.id
  end

  def user_is_owner_of_organization?
    record.organizations.exists?(owner_id: user.id)
  end

  class Scope < Scope
    def resolve
      if user.role == 'employee'
        employee_scope
      else
        owner_scope
      end
    end

    private

    def employee_scope
      scope.left_joins(:employments).where(employments: { organization_id: user.organizations.pluck(:id) })
           .or(scope.where(id: user.id)).distinct
    end

    def owner_scope
      scope.left_joins(:employments).where(employments: { organization_id: user.owned_organizations.pluck(:id) })
           .or(scope.where(id: user.id)).distinct
    end
  end
end
