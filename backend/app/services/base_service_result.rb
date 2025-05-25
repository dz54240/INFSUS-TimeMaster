# frozen_string_literal: true

class BaseServiceResult
  attr_reader :data, :errors

  def initialize(success:, data: nil, errors: [])
    @success = success
    @data = data
    @errors = errors
  end

  def self.success(data = nil)
    new(success: true, data:)
  end

  def self.failure(errors = [])
    new(success: false, errors:)
  end

  def success?
    @success
  end

  def failure?
    !success?
  end
end
