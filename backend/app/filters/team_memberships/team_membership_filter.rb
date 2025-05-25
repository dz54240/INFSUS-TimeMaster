# frozen_string_literal: true

module TeamMemberships
  class TeamMembershipFilter < BaseFilter
    def call
      filter_by_team

      super
    end

    private

    def filter_by_team
      return if team_id.blank?

      @scope = scope.where(team_id: team_id)
    end

    def team_id
      params[:team_id]
    end
  end
end
