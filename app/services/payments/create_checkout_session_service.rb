# frozen_string_literal: true

module Payments
  # Creates a Stripe Checkout Session for an order and updates the order with session ID.
  # Associates the session with the user's Stripe Customer when available.
  class CreateCheckoutSessionService < ApplicationService
    # @param order [Order] Order to create checkout session for
    def initialize(order:)
      @order = order
    end

    # @return [String] Stripe Checkout Session URL for redirect
    def call
      customer_id = FindOrCreateStripeCustomerService.call(user: @order.user)

      session_params = {
        payment_method_types: ["card"],
        customer: customer_id,
        line_items: [
          {
            price_data: {
              currency: @order.currency,
              product_data: { name: @order.description },
              unit_amount: @order.amount_cents
            },
            quantity: 1
          }
        ],
        mode: "payment",
        success_url: "#{@order.success_url}?payment=success",
        cancel_url:  "#{@order.cancel_url}?payment=cancelled",
        metadata: { order_id: @order.id }
      }

      session = Stripe::Checkout::Session.create(session_params)

      @order.update!(
        stripe_checkout_session_id: session.id,
        status: :processing
      )

      session.url
    end
  end
end
