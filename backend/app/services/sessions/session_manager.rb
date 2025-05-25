# frozen_string_literal: true

module Sessions
  class SessionManager
    def initialize(params, current_session)
      @user_email = params.dig('data', 'email')
      @user_password = params.dig('data', 'password')
      @current_session = current_session
    end

    def create_session
      return unless valid_credentials?

      session_data
    end

    def destroy_session
      current_session.update(expired_at: Time.current)
    end

    private

    attr_reader :user_email, :user_password
    attr_accessor :current_session

    def session_data
      {
        token: session.token,
        user: UserSerializer.new(user).serializable_hash[:data]
      }
    end

    def valid_credentials?
      user.present? && user.authenticate(user_password)
    end

    def session
      @session ||= Session.create(user_id: user.id)
    end

    def user
      @user ||= User.find_by(email: user_email)
    end
  end
end
