# frozen_string_literal: true

class SessionPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  def update?
    owned?
  end

  def destroy?
    false
  end

  private

  def owned?
    record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
