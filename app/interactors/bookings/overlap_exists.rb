# frozen_string_literal: true

module Bookings
  # Checks if any occupying booking overlaps with the given range for a court and date.
  # Excludes the given booking_id when provided (e.g. for update scenarios).
  #
  # @example
  #   result = Bookings::OverlapExists.call(
  #     court_id: 1, date: Date.current,
  #     starts_at: time1, ends_at: time2, exclude_booking_id: booking.id
  #   )
  #   result.overlaps # => true/false
  class OverlapExists < BaseInteractor
    include FormatsTimeRange

    delegate :court_id, :date, :starts_at, :ends_at, :exclude_booking_id, to: :context

    def call
      context.overlaps = overlapping_booking_exists?
    end

    private

    # @return [Boolean]
    def overlapping_booking_exists?
      return false unless court_id && date && starts_at && ends_at

      starts = time_str(starts_at)
      ends   = time_str(ends_at)

      scope = Booking.occupying
                    .where(court_id: court_id, date: date)
                    .where("starts_at < ? AND ends_at > ?", ends, starts)
      scope = scope.where.not(id: exclude_booking_id) if exclude_booking_id.present?
      scope.exists?
    end
  end
end
