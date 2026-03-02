# frozen_string_literal: true

module Payments
  # Marks a Stripe order as paid, creates the payment audit record, and fulfills the orderable.
  class FulfillOrderJob < ApplicationJob
    include Payments::FulfillsOrderable

    queue_as :payments

    # @param stripe_session_id [String] Stripe Checkout Session ID
    # @return [void]
    def perform(stripe_session_id)
      order = Order.find_by(stripe_checkout_session_id: stripe_session_id)
      return unless order
      return if order.paid?

      ActiveRecord::Base.transaction do
        order.update!(status: :paid, paid_at: Time.current)

        stripe_session = Stripe::Checkout::Session.retrieve(
          { id: stripe_session_id, expand: ["payment_intent"] }
        )

        payment_intent = stripe_session.payment_intent
        order.create_payment!(
          amount_cents:             order.amount_cents,
          currency:                 order.currency,
          status:                   :succeeded,
          stripe_payment_intent_id: payment_intent&.id,
          payment_method_type:      payment_intent&.payment_method_types&.first,
          stripe_raw:               stripe_session.as_json
        )

        fulfill(order.orderable)
      end
    end
  end
end
