# frozen_string_literal: true

module Invitations
  class InvitationFilter < BaseFilter
    def call
      filter_by_organization

      super
    end
  end
end
