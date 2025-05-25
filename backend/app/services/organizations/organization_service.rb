# frozen_string_literal: true

module Organizations
  class OrganizationService < BaseService
    def perform
      set_owner

      super
    end

    private

    def set_owner
      record.owner_id = current_user.id
    end
  end
end
