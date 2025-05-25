# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    owner? || employed?
  end

  def create?
    user.role == 'owner'
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def permitted_attributes_for_create
    [:name, :description, :established_at]
  end

  def permitted_attributes_for_update
    [:name, :description, :established_at]
  end

  private

  def owner?
    record.owner_id == user.id
  end

  def employed?
    record.users.exists?(id: user.id)
  end

  class Scope < Scope
    def resolve
      if user.role == 'employee'
        scope.joins(:employments).where(employments: { user_id: user.id })
      else
        scope.where(owner_id: user.id)
      end
    end
  end
end
