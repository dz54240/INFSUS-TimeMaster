# frozen_string_literal: true

module Employments
  class EmploymentFilter < BaseFilter
    def call
      filter_by_organization

      super
    end
  end
end
