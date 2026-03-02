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
      return unless booking.schedule_attributes_present?

      return unless out_of_hours?

      message = I18n.t("activerecord.errors.models.booking.attributes.starts_at.out_of_hours",
        hours: "#{BookingSchedule::BUSINESS_HOURS_START}h–#{BookingSchedule::BUSINESS_HOURS_END}h")
      fail_with!(error: message, message: message, attribute: :starts_at)
    end

    private

    # @return [Boolean] true when booking is outside business hours
    def out_of_hours?
      starts_before_opening? || ends_after_closing?
    end

    # @return [Boolean] true when starts_at is before BUSINESS_HOURS_START
    def starts_before_opening?
      booking.starts_at.hour < BookingSchedule::BUSINESS_HOURS_START
    end

    # @return [Boolean] true when ends_at is after BUSINESS_HOURS_END
    def ends_after_closing?
      booking.ends_at.hour > BookingSchedule::BUSINESS_HOURS_END
    end
  end
end
