# frozen_string_literal: true

module Teams
  class TeamFilter < BaseFilter
    def call
      filter_by_organization

      super
    end
  end
end
