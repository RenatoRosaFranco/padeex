# frozen_string_literal: true

# Creates a booking atomically using a row-level lock on the court to prevent race conditions.
#
# @example
#   BookingCreatorService.call(court: court, user: user, date: date, starts_at: "08:00")
class BookingCreatorService < ApplicationService
  # @param court [Court] court to book
  # @param user [User] user making the booking
  # @param date [Date] booking date
  # @param starts_at [String] start time (e.g. "08:00")
  def initialize(court:, user:, date:, starts_at:)
    @court     = court
    @user      = user
    @date      = date
    @starts_at = starts_at
  end

  # Creates booking with row-level lock to prevent race conditions.
  # @return [Booking] the created booking
  def call
    booking = nil

    @court.with_lock do
      ends_at = Time.zone.parse("#{@date} #{@starts_at}") + BookingSchedule::SLOT_DURATION.minutes

      booking = Booking.new(
        court:     @court,
        user:      @user,
        date:      @date,
        starts_at: @starts_at,
        ends_at:   ends_at.strftime("%H:%M:%S"),
        status:    :active
      )

      booking.save
    end

    booking
  end
end
