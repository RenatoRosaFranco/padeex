# frozen_string_literal: true

module Bookings
  # Validates that booking starts_at and ends_at are within business hours.
  #
  # @example
  #   result = Bookings::ValidateBusinessHours.call(booking: booking)
  #   booking.errors.add(:starts_at, result.message) if result.failure?
  class ValidateBusinessHours < BaseInteractor
    delegate :booking, to: :context

    def call
      return unless booking.starts_at && booking.ends_at

      if out_of_hours?
        context.fail!(
          message: I18n.t("activerecord.errors.models.booking.attributes.starts_at.out_of_hours",
            hours: "#{BookingSchedule::BUSINESS_HOURS_START}h–#{BookingSchedule::BUSINESS_HOURS_END}h"),
          attribute: :starts_at
        )
      end
    end

    private

    def out_of_hours?
      booking.starts_at.hour < BookingSchedule::BUSINESS_HOURS_START ||
        booking.ends_at.hour > BookingSchedule::BUSINESS_HOURS_END
    end
  end
end
