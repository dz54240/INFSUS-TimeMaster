# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonResponses
  include Pundit::Authorization
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
  before_action :authorize_model, only: :index
  after_action :verify_policy_scoped, only: :index

  def current_user
    return nil if current_session.nil?

    @current_user ||= current_session.user
  end

  private

  def authenticate_user
    render_unauthorized('Invalid token') if current_user.nil?
  end

  def current_session
    return nil if headers_token.nil?

    @current_session ||= Session.find_by(token: headers_token, expired_at: nil)
  end

  def headers_token
    return nil if request_headers.nil?

    request_headers.split(' ')[1]
  end

  def resolved_scope
    apply_filters(policy_scope(class_name))
  end

  def apply_filters(scope)
    return scope if filter_class.blank?

    filter_class.new(scope, params).call
  end

  def filter_class
    "#{class_name.to_s.pluralize}::#{class_name}Filter".safe_constantize
  end

  def request_headers
    request.headers['Authorization']
  end

  def process_service(params)
    result = service(params).perform

    if result.success?
      render_json(result.data)
    else
      render_errors(result.errors)
    end
  end

  def service(params)
    @service ||= service_class.new(@resource || @new_resource, params, current_user)
  end

  def service_class
    "#{class_name.to_s.pluralize}::#{class_name}Service".constantize
  end

  def authorize_model
    authorize class_name
  end

  def create_resource
    authorize @new_resource = class_name.new
  end

  def preload_resource
    authorize @resource = class_name.find(params[:id])
  end

  def resolved_includes
    class_name.serializer_includes
  end

  def class_name
    controller_name.classify.constantize
  end

  def update_params
    return {} if data_params.blank?

    params.require(:data).permit(policy(@resource).permitted_attributes_for_update)
  end

  def create_params
    return {} if data_params.blank?

    data_params.permit(policy(class_name).permitted_attributes_for_create)
  end

  def data_params
    params[:data]
  end
end
