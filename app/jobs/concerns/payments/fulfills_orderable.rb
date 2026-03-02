# frozen_string_literal: true

module Payments
  module FulfillsOrderable
    extend ActiveSupport::Concern

    private

    # Updates orderable status based on type.
    # TournamentRegistration → confirmed, Booking → active.
    #
    # @param orderable [TournamentRegistration, Booking]
    # @return [void]
    def fulfill(orderable)
      case orderable
      when TournamentRegistration then orderable.update!(status: :confirmed)
      when Booking                then orderable.update!(status: :active)
      end
    end
  end
end
