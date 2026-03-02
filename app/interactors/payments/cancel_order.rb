# frozen_string_literal: true

module Payments
  # Cancels an order and its orderable (TournamentRegistration or Booking)
  # when found by Stripe checkout session id.
  #
  # @example
  #   Payments::CancelOrder.call(stripe_session_id: "cs_xxx")
  class CancelOrder < BaseInteractor
    delegate :stripe_session_id, to: :context

    def call
      order = find_order
      return unless order

      order.update!(status: :cancelled)
      cancel_orderable(order)
    end

    private

    # @return [Order, nil]
    def find_order
      Order.find_by(stripe_checkout_session_id: stripe_session_id)
    end

    # @param order [Order]
    # @return [void]
    def cancel_orderable(order)
      orderable = order.orderable
      case orderable
      when TournamentRegistration, Booking
        orderable.update!(status: :cancelled)
      end
    end
  end
end
