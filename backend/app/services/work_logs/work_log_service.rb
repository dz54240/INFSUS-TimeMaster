# frozen_string_literal: true

module WorkLogs
  class WorkLogService < BaseService
    validate :project_accessible

    def perform
      return BaseServiceResult.failure(errors.full_messages) unless valid?

      calculate_cost && set_user_id && record.assign_attributes(params)

      save_record
    end

    private

    def calculate_cost
      return owner_cost if current_user.role == 'owner'

      employee_cost
    end

    def owner_cost
      return 0 if record.user.hourly_rate.blank?

      record.cost = record.user.hourly_rate * work_time
    end

    def employee_cost
      return 0 if current_user.hourly_rate.blank?

      record.cost = current_user.hourly_rate * work_time
    end

    def set_user_id
      record.user_id = current_user.id
    end

    def project_accessible
      return if project_id.nil?
      return if project_scope.exists?(id: project_id)

      errors.add(:project, 'must be accessible')
    end

    def project_scope
      ProjectPolicy::Scope.new(current_user, Project).resolve
    end

    def project_id
      params[:project_id]
    end

    def work_time
      return 0 unless start_time && end_time

      (end_time.to_time - start_time.to_time) / 3600.0
    end

    def start_time
      params[:start_time]
    end

    def end_time
      params[:end_time]
    end
  end
end
