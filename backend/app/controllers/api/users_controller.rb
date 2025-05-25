# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate_user, except: [:create]
    before_action :preload_resource, only: [:show, :update, :destroy]
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

    def update
      process_service(update_params)
    end

    def destroy
      @resource.destroy

      head :no_content
    end
  end
end
