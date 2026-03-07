# frozen_string_literal: true

module Payments
  # Creates an OpenPix/Woovi PIX charge and stores the charge data on the order.
  # Updates order with brCode, QR code URL, expiry, and sets status to :processing.
  class CreatePixChargeService < ApplicationService
    # Constants
    CORRELATION_PREFIX = "padeex"

    # @param order [Order] order to create a PIX charge for
    def initialize(order:)
      @order = order
    end

    # @return [Order] the updated order with PIX charge data
    # @raise [OpenpixClient::Error] on API or network failure
    def call
      correlation_id = "#{CORRELATION_PREFIX}-#{@order.id}"

      response = OpenpixClient.new.create_charge(
        correlation_id: correlation_id,
        value:          @order.amount_cents,
        comment:        @order.description
      )

      charge = response["charge"] or raise OpenpixClient::Error, "Missing charge in OpenPix response"

      @order.update!(
        openpix_correlation_id: correlation_id,
        pix_brcode:             charge["brCode"],
        pix_qrcode_url:         charge["qrCodeImage"],
        pix_expires_at:         charge["expiresDate"] ? Time.zone.parse(charge["expiresDate"]) : nil,
        status:                 :processing
      )

      @order
    end
  end
end
