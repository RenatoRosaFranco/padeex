# frozen_string_literal: true

require "openssl"
require "base64"

module Payments
  # Verifies OpenPix/Woovi webhook signature using RSA-SHA256.
  # Skips verification when OPENPIX_WEBHOOK_PUBLIC_KEY is not set (e.g. development).
  #
  # @example
  #   Payments::VerifyOpenpixWebhookService.call(
  #     raw_body: request.body.read,
  #     signature_header: request.headers["x-webhook-signature"]
  #   )
  class VerifyOpenpixWebhookService < ApplicationService
    # @param raw_body [String] raw request body (before JSON parse)
    # @param signature_header [String, nil] x-webhook-signature header value
    def initialize(raw_body:, signature_header:)
      @raw_body         = raw_body
      @signature_header = signature_header
    end

    # Verifies signature against OpenPix public key.
    #
    # @return [Boolean] true when valid or when verification is skipped (no key configured)
    def call
      public_key_b64 = Openpix::WEBHOOK_PUBLIC_KEY_B64
      return true if public_key_b64.blank?

      return false if @signature_header.blank?

      public_key = OpenSSL::PKey::RSA.new(Base64.decode64(public_key_b64))
      signature  = Base64.decode64(@signature_header)
      public_key.verify(OpenSSL::Digest::SHA256.new, signature, @raw_body)
    rescue OpenSSL::PKey::PKeyError
      false
    end
  end
end
