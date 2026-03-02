# frozen_string_literal: true

# Computes available time slots for a court on a given date.
#
# @example
#   AvailabilityService.call(court: court, date: Date.today)
#   # => [{ starts_at: "07:00", ends_at: "08:00", available: true }, ...]
class AvailabilityService < ApplicationService
  SLOT_DURATION        = BookingSchedule::SLOT_DURATION
  BUSINESS_HOURS_START = BookingSchedule::BUSINESS_HOURS_START
  BUSINESS_HOURS_END   = BookingSchedule::BUSINESS_HOURS_END

  # @param court [Court] court to check availability for
  # @param date [Date] date to compute slots for
  def initialize(court:, date:)
    @court = court
    @date  = date
  end

  # @return [Array<Hash>] slots with starts_at, ends_at, and available flag
  def call
    all_slots.map do |slot_start|
      slot_end = slot_start + SLOT_DURATION.minutes
      {
        starts_at: slot_start.strftime("%H:%M"),
        ends_at:   slot_end.strftime("%H:%M"),
        available: available?(slot_start, slot_end)
      }
    end
  end

  private

  # @return [Array<Time>] all time slots for the date within business hours
  def all_slots
    slots   = []
    current = Time.zone.parse("#{@date} #{BUSINESS_HOURS_START.to_s.rjust(2, '0')}:00:00")
    ending  = Time.zone.parse("#{@date} #{BUSINESS_HOURS_END.to_s.rjust(2, '0')}:00:00")

    while current + SLOT_DURATION.minutes <= ending
      slots << current
      current += SLOT_DURATION.minutes
    end

    slots
  end

  # @param slot_start [Time] slot start time
  # @param slot_end [Time] slot end time
  # @return [Boolean] true when slot is in the future and not blocked by booking or time_block
  def available?(slot_start, slot_end)
    return false if slot_start < Time.current
    return false if booking_exists?(slot_start, slot_end)
    return false if time_block_exists?(slot_start, slot_end)
    true
  end

  # @param slot_start [Time] slot start time
  # @param slot_end [Time] slot end time
  # @return [Boolean] true when an active or pending_payment booking overlaps the slot
  def booking_exists?(slot_start, slot_end)
    starts = slot_start.strftime("%H:%M:%S")
    ends   = slot_end.strftime("%H:%M:%S")
    @court.bookings.where(status: %i[active pending_payment], date: @date)
          .where("starts_at < ? AND ends_at > ?", ends, starts)
          .exists?
  end

  # @param slot_start [Time] slot start time
  # @param slot_end [Time] slot end time
  # @return [Boolean] true when a time block overlaps the slot
  def time_block_exists?(slot_start, slot_end)
    starts = slot_start.strftime("%H:%M:%S")
    ends   = slot_end.strftime("%H:%M:%S")
    @court.time_blocks.where(date: @date)
          .where("starts_at < ? AND ends_at > ?", ends, starts)
          .exists?
  end
end
