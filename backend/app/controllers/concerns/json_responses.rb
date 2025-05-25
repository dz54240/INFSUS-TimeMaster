# frozen_string_literal: true

module JsonResponses
  extend ActiveSupport::Concern
  def render_json(data)
    render json: serializer(data).serializable_hash.to_json, status: :ok
  end

  def render_json_created(data)
    render json: serializer(data).serializable_hash.to_json, status: :created
  end

  def render_json_bad_request(data)
    render json: { errors: data }, status: :bad_request
  end

  def render_unauthorized(error)
    render json: { errors: [error] }, status: :unauthorized
  end

  def render_errors(errors)
    render json: { errors: }, status: :bad_request
  end

  def render_forbidden
    render json: { errors: ['forbidden'] }, status: :forbidden
  end

  def render_session_data(session_info)
    render json: { data: session_info }, status: :created
  end

  def render_credentials_error
    render json: { errors: ['credentials are invalid'] }, status: :bad_request
  end

  def record_not_found(exception)
    render json: {
      errors: {
        database: ["#{exception.model} not found"]
      }
    }, status: :not_found
  end

  private

  def serializer(data)
    serializer_class.new(data, include: resolved_includes, params: { current_user: current_user })
  rescue NameError
    raise "Serializer not found for #{class_name}"
  end

  def serializer_class
    serializer_class_name.constantize
  end

  def serializer_class_name
    "#{controller_name.classify}Serializer"
  end
end
