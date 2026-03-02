# frozen_string_literal: true

class HealthcheckSerializer < ActiveModel::Serializer
  # Attributes
  attributes :status, :timestamp, :version

  # @param attr [Symbol] attribute name
  def read_attribute_for_serialization(attr)
    object.public_send(attr)
  end
end
