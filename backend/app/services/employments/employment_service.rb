# frozen_string_literal: true

module Employments
  class EmploymentService < BaseService
    validate :validate_organization_token

    def perform
      return BaseServiceResult.failure(errors.full_messages) unless valid?

      assign_data
      return BaseServiceResult.success(record) if save_record

      BaseServiceResult.failure(record.errors.full_messages)
    end

    private

    def save_record
      ActiveRecord::Base.transaction do
        record.save!
        token.update!(token_used: true)
        true
      rescue ActiveRecord::RecordInvalid
        record.errors.full_messages.each { |msg| errors.add(:base, msg) }
        false
      end
    end

    def assign_data
      record.user_id = current_user.id
      record.organization_id = organization.id
    end

    def validate_organization_token
      return unless token.nil?

      errors.add(:organization_token, 'is invalid')
    end

    def token
      @token ||= Invitation.find_by(token: organization_token, token_used: false)
    end

    def organization
      token.organization
    end

    def organization_token
      params[:organization_token]
    end
  end
end
