# frozen_string_literal: true

module Payments
  # Delegates Stripe session cancellation to the CancelOrder interactor.
  class CancelOrderJob < ApplicationJob
    queue_as :payments

    # @param stripe_session_id [String] Stripe Checkout Session ID to cancel
    # @return [void]
    def perform(stripe_session_id)
      Payments::CancelOrder.call(stripe_session_id: stripe_session_id)
    end
  end
end
