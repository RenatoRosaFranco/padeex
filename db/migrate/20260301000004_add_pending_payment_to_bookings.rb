# frozen_string_literal: true

# String-backed enum — no DB column change needed.
# The unique index on bookings only covers status = 'active', so pending_payment
# rows do not conflict with the index. This migration serves as an audit trail.
class AddPendingPaymentToBookings < ActiveRecord::Migration[8.1]
  def change
    # no-op
  end
end
