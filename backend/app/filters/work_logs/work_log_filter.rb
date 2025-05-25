# frozen_string_literal: true

module WorkLogs
  class WorkLogFilter < BaseFilter
    def call
      filter_by_organization
      @scope = apply_filters

      super
    end

    private

    def apply_filters
      scope
        .then { |s| apply_current_week_filter(s) }
        .then { |s| apply_pagination(s) }
    end

    def apply_current_week_filter(scope)
      return scope unless current_week == 'true'

      scope.where(start_time: Time.current.beginning_of_week..Time.current.end_of_week)
    end

    def apply_pagination(scope)
      return scope unless skip && limit

      scope.offset(skip).limit(limit)
    end

    def current_week
      params[:current_week]
    end

    def skip
      params[:skip]
    end

    def limit
      params[:limit]
    end
  end
end
