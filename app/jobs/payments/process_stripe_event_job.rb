# frozen_string_literal: true

module Payments
  class ProcessStripeEventJob < ApplicationJob
    queue_as :payments

    # Processes a Stripe webhook event.
    # @param event_json [Hash] Stripe event payload (parsed JSON)
    # @return [void]
    def perform(event_json)
      event = Stripe::Event.construct_from(event_json.deep_symbolize_keys)
      Payments::ProcessStripeEvent.call(event: event)
    end
  end
end
