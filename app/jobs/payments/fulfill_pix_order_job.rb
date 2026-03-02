# frozen_string_literal: true

module Payments
  # Marks a PIX order as paid, creates the payment audit record, and fulfills the orderable.
  class FulfillPixOrderJob < ApplicationJob
    include Payments::FulfillsOrderable

    queue_as :payments

    # @param correlation_id [String] OpenPix webhook correlation ID
    # @param raw_payload    [Hash, nil] full OpenPix charge payload for audit (optional)
    # @return [void]
    def perform(correlation_id, raw_payload = nil)
      order = Order.find_by(openpix_correlation_id: correlation_id)
      return unless order
      return if order.paid?

      ActiveRecord::Base.transaction do
        order.update!(status: :paid, paid_at: Time.current)

        order.create_payment!(
          amount_cents:        order.amount_cents,
          currency:            order.currency,
          status:              :succeeded,
          payment_method_type: "pix",
          stripe_raw:          raw_payload
        )

        fulfill(order.orderable)
      end
    end
  end
end
