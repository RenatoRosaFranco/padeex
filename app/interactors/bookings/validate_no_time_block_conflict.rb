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
      return unless booking.court_id && booking.date && booking.starts_at && booking.ends_at

      if block_exists?
        context.fail!(
          message: I18n.t("activerecord.errors.models.booking.attributes.starts_at.blocked"),
          attribute: :starts_at
        )
      end
    end

    private

    def block_exists?
      starts = booking.starts_at.strftime("%H:%M:%S")
      ends   = booking.ends_at.strftime("%H:%M:%S")

      TimeBlock.where(court_id: booking.court_id, date: booking.date)
               .where("starts_at < ? AND ends_at > ?", ends, starts)
               .exists?
    end
  end
end
