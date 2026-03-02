# frozen_string_literal: true

module Payments
  # Cancels a booking and its associated order when payment was never completed.
  # Enqueued with a 15-minute delay after a pending_payment booking is created.
  class ExpirePendingBookingJob < ApplicationJob
    queue_as :payments

    # @param booking_id [Integer, String] Booking ID to expire
    # @return [void]
    def perform(booking_id)
      booking = Booking.find_by(id: booking_id)
      return unless booking&.pending_payment?

      ActiveRecord::Base.transaction do
        booking.update!(status: :cancelled)
        booking.order&.update!(status: :cancelled)
      end
    end
  end
end
