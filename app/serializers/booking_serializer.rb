# frozen_string_literal: true

class BookingSerializer < ActiveModel::Serializer
  attributes :id, :court_id, :user_id, :date, :starts_at, :ends_at, :status, :tenant_id, :created_at

  # @return [String] start time formatted as "HH:MM"
  def starts_at
    object.starts_at.strftime("%H:%M")
  end

  # @return [String] end time formatted as "HH:MM"
  def ends_at
    object.ends_at.strftime("%H:%M")
  end
end
