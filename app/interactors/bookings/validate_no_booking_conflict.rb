# frozen_string_literal: true

module Bookings
  # Validates no overlapping active booking for same court and date.
  #
  # @example
  #   result = Bookings::ValidateNoBookingConflict.call(booking: booking)
  #   booking.errors.add(:starts_at, result.message) if result.failure?
  class ValidateNoBookingConflict < BaseInteractor
    delegate :booking, to: :context

    def call
      return unless booking.schedule_attributes_present?

      result = Bookings::OverlapExists.call(
        court_id:           booking.court_id,
        date:               booking.date,
        starts_at:          booking.starts_at,
        ends_at:            booking.ends_at,
        exclude_booking_id: booking.id
      )

      return unless result.overlaps

      message = I18n.t("activerecord.errors.models.booking.attributes.starts_at.already_reserved")
      fail_with!(error: message, message: message, attribute: :starts_at)
    end
  end
end
