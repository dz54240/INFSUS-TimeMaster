# frozen_string_literal: true

class BaseService
  include ActiveModel::Validations

  def initialize(record, params, current_user = nil)
    @record = record
    @params = params
    @current_user = current_user
    @result = nil
  end

  def perform
    return BaseServiceResult.failure(errors.full_messages) unless valid?

    record.assign_attributes(params)

    save_record
  end

  private

  def save_record
    return BaseServiceResult.success(record) if record.save

    BaseServiceResult.failure(record.errors.full_messages)
  end

  attr_accessor :record, :params, :current_user
end
