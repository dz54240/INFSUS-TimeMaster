# frozen_string_literal: true

module TeamMemberships
  class TeamMembershipService < BaseService
    validate :team_accessible
    validate :user_accessible

    private

    def team_accessible
      return if team_id.nil?
      return if team_scope.exists?(id: team_id)

      errors.add(:team, 'must be accessible')
    end

    def team_scope
      TeamPolicy::Scope.new(current_user, Team).resolve
    end

    def team_id
      params[:team_id]
    end

    def user_accessible
      return if user_id.nil?
      return if user_scope.exists?(id: user_id)

      errors.add(:user, 'must be accessible')
    end

    def user_scope
      UserPolicy::Scope.new(current_user, User).resolve
    end

    def user_id
      params[:user_id]
    end
  end
end
