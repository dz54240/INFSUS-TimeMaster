# frozen_string_literal: true

class BaseFilter
  def initialize(scope, params)
    @scope = scope
    @params = params
  end

  def call
    scope
  end

  private

  attr_reader :scope, :params

  def filter_param(key)
    params[key] if params.key?(key)
  end

  def filter_by_organization
    return unless filter_param(:organization_id)

    @scope = scope.where(organization_id: filter_param(:organization_id))
  end
end
