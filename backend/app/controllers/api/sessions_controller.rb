# frozen_string_literal: true

module Api
  class SessionsController < ApplicationController
    before_action :authenticate_user, except: [:create]

    def create
      return render_credentials_error unless session_data

      render_session_data(session_data)
    end

    def destroy
      session_manager.destroy_session

      head :no_content
    end

    private

    def session_data
      @session_data ||= session_manager.create_session
    end

    def session_manager
      @session_manager ||= Sessions::SessionManager.new(params, @current_session)
    end
  end
end
