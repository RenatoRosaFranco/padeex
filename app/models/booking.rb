# frozen_string_literal: true

class Booking < ApplicationRecord
  include BelongsToTenant
  include BookingSchedule

  # Associations
  belongs_to :court
  belongs_to :user

  # Enums
  enum :status, { active: "active", cancelled: "cancelled" }

  # Validations
  validates :date, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :status, presence: true

  validate :date_not_in_past
  validate :within_business_hours
  validate :no_booking_conflict, on: :create
  validate :no_time_block_conflict, on: :create

  # Scopes
  scope :active,    -> { where(status: :active) }
  scope :for_date,  ->(date) { where(date: date) }

  # @return [Boolean] true when booking is active and within cancellation window
  def cancellable?
    return false unless active?
    Time.current < booking_start_datetime - CANCELLATION_WINDOW.hours
  end

  # Cancels the booking. Raises RecordInvalid if not cancellable.
  # @return [Boolean] true when update succeeds
  def cancel!
    raise ActiveRecord::RecordInvalid, self unless cancellable?
    update!(status: :cancelled)
  end

  private

  # @return [Time] booking start as Time in current zone
  def booking_start_datetime
    Time.zone.parse("#{date} #{starts_at.strftime('%H:%M:%S')}")
  end

  # Validates date is not in the past.
  # @return [void]
  def date_not_in_past
    return unless date
    errors.add(:date, :invalid_past) if date < Date.current
  end

  # Validates booking is within BUSINESS_HOURS_START and BUSINESS_HOURS_END.
  # @return [void]
  def within_business_hours
    result = Bookings::ValidateBusinessHours.call(booking: self)
    errors.add(result.attribute, result.message) if result.failure?
  end

  # Validates no overlapping active booking for same court and date.
  # @return [void]
  def no_booking_conflict
    result = Bookings::ValidateNoBookingConflict.call(booking: self)
    errors.add(result.attribute, result.message) if result.failure?
  end

  # Validates no overlapping time block for same court and date.
  # @return [void]
  def no_time_block_conflict
    result = Bookings::ValidateNoTimeBlockConflict.call(booking: self)
    errors.add(result.attribute, result.message) if result.failure?
  end
end
