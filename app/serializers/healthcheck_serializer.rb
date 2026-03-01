# frozen_string_literal: true

class HealthcheckSerializer < ActiveModel::Serializer
  attributes :status, :timestamp, :version

  def read_attribute_for_serialization(attr)
    object.public_send(attr)
  end
end
