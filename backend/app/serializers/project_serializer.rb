# frozen_string_literal: true

class ProjectSerializer
  include JSONAPI::Serializer

  set_type :project
  set_id :id

  attributes :name
  attributes :description
  attribute :start_date
  attribute :end_date
  attribute :budget_amount, if: ->(_object, params) { params[:current_user].role == 'owner' }
  attribute :current_cost, if: ->(_object, params) { params[:current_user].role == 'owner' }
  attribute :total_hours_spent
  attribute :organization_id
  attributes :created_at
  attributes :updated_at
end
