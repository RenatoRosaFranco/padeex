# frozen_string_literal: true

class CourtSerializer < ActiveModel::Serializer
  # Attributes
  attributes :id, :name, :court_type, :status, :tenant_id, :created_at
end
