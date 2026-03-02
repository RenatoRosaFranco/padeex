# frozen_string_literal: true

module Webhooks
  # Receives OpenPix/Woovi webhook events.
  # Signature is verified via RSA-SHA256 using Woovi's public key.
  # If OPENPIX_WEBHOOK_PUBLIC_KEY is not set, verification is skipped (development).
  class OpenpixController < ActionController::API
    def create
      raw_body = request.body.read

      unless Payments::VerifyOpenpixWebhookService.call(
        raw_body: raw_body,
        signature_header: request.headers["x-webhook-signature"]
      )
        return head :unauthorized
      end

      payload = JSON.parse(raw_body)
      Payments::ProcessOpenpixEventJob.perform_later(payload)
      head :ok
    rescue JSON::ParserError
      head :bad_request
    end
  end
end
