# frozen_string_literal: true

module Bookings
  # Validates no overlapping time block for same court and date.
  #
  # @example
  #   result = Bookings::ValidateNoTimeBlockConflict.call(booking: booking)
  #   booking.errors.add(:starts_at, result.message) if result.failure?
  class ValidateNoTimeBlockConflict < BaseInteractor
    delegate :booking, to: :context

    def call
      return unless booking.schedule_attributes_present?

      result = TimeBlocks::OverlapsWithRange.call(
        court_id:  booking.court_id,
        date:      booking.date,
        starts_at: booking.starts_at,
        ends_at:   booking.ends_at
      )

      return unless result.overlaps

      message = I18n.t("activerecord.errors.models.booking.attributes.starts_at.blocked")
      fail_with!(error: message, message: message, attribute: :starts_at)
    end
  end
end
