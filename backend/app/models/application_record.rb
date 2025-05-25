# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  default_scope { includes(default_includes).order(created_at: :desc) }

  def self.serializer_includes
    []
  end

  def self.default_includes
    []
  end
end
