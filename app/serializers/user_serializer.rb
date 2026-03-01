# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  # Attributes
  attributes :id, :email, :name, :initials, :kind, :created_at
end
