# frozen_string_literal: true

module Onboarding
  # Orchestrates the daily onboarding pipeline:
  #   1. Bulk-decrements `onboarding_days_remaining` for all pending users in one SQL UPDATE.
  #   2. Dispatches SendRemindersJob and PurgeExpiredJob as independent background jobs
  #      so both fan-outs run in parallel.
  #
  # Scheduled daily at 06:00 via config/recurring.yml.
  class DailyJob < ApplicationJob
    queue_as :default

    def perform
      decrement_pending_onboarding_days

      SendRemindersJob.perform_later
      PurgeExpiredJob.perform_later
    end

    private

    # Bulk-decrements onboarding_days_remaining for all pending users with days > 0.
    # @return [Integer] number of rows updated
    def decrement_pending_onboarding_days
      User.pending_onboarding.where("onboarding_days_remaining > 0")
          .update_all("onboarding_days_remaining = onboarding_days_remaining - 1")
    end
  end
end
