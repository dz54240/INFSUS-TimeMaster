# frozen_string_literal: true

module Projects
  class ProjectFilter < BaseFilter
    def call
      filter_by_organization

      super
    end
  end
end
