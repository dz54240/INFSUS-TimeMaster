# frozen_string_literal: true

module Api
  class TeamMembershipsController < ApplicationController
    before_action :authenticate_user
    before_action :preload_resource, only: [:show, :destroy]
    before_action :create_resource, only: [:create]

    def index
      render_json(resolved_scope)
    end

    def show
      render_json(@resource)
    end

    def create
      process_service(create_params)
    end

    def destroy
      @resource.destroy

      head :no_content
    end
  end
end
