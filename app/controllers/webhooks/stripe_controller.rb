# frozen_string_literal: true

module Webhooks
  # Handles incoming Stripe webhook events.
  # Verifies signature and enqueues async processing.
  class StripeController < ActionController::API
    # Receives Stripe webhook POST, verifies signature, enqueues {Payments::ProcessStripeEventJob}.
    # Returns 200 on success, 400 on invalid payload or signature.
    #
    # @return [void]
    def create
      payload    = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV["STRIPE_WEBHOOK_SECRET"]
      )

      Payments::ProcessStripeEventJob.perform_later(event.as_json)
      head :ok
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      head :bad_request
    end
  end
end
