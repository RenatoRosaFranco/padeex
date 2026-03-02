# frozen_string_literal: true

module Payments
  # Processes Stripe webhook events and enqueues the appropriate jobs.
  #
  # @example
  #   Payments::ProcessStripeEvent.call(event: stripe_event)
  class ProcessStripeEvent < BaseInteractor
    delegate :event, to: :context

    def call
      case event.type
      when "checkout.session.completed"
        handle_checkout_completed
      when "checkout.session.expired"
        handle_checkout_expired
      end
    end

    private

    # Enqueues FulfillOrderJob when checkout session is paid.
    # @return [void]
    def handle_checkout_completed
      session = event.data.object
      Payments::FulfillOrderJob.perform_later(session.id) if session.payment_status == "paid"
    end

    # Enqueues CancelOrderJob when checkout session has expired.
    # @return [void]
    def handle_checkout_expired
      session = event.data.object
      Payments::CancelOrderJob.perform_later(session.id)
    end
  end
end
