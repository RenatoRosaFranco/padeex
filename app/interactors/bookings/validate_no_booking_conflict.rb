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
      return unless booking.court_id && booking.date && booking.starts_at && booking.ends_at

      if conflict_exists?
        context.fail!(
          message: I18n.t("activerecord.errors.models.booking.attributes.starts_at.already_reserved"),
          attribute: :starts_at
        )
      end
    end

    private

    def conflict_exists?
      starts = booking.starts_at.strftime("%H:%M:%S")
      ends   = booking.ends_at.strftime("%H:%M:%S")

      Booking.active
             .where(court_id: booking.court_id, date: booking.date)
             .where("starts_at < ? AND ends_at > ?", ends, starts)
             .where.not(id: booking.id)
             .exists?
    end
  end
end
