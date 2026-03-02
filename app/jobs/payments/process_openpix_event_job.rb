# frozen_string_literal: true

module Payments
  # Processes OpenPix webhook events. Enqueues {FulfillPixOrderJob} when charge is completed.
  class ProcessOpenpixEventJob < ApplicationJob
    queue_as :payments

    # Extracts charge from payload and enqueues fulfillment if status is COMPLETED.
    #
    # @param payload [Hash] OpenPix webhook event payload
    # @return [void]
    def perform(payload)
      charge = payload["charge"]
      return unless charge && charge["status"] == "COMPLETED"

      Payments::FulfillPixOrderJob.perform_later(charge["correlationID"], charge)
    end
  end
end
