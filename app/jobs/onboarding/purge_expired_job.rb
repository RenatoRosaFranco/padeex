# frozen_string_literal: true

module Onboarding
  # Collects users whose onboarding window has expired (days_remaining == 0)
  # and fans out one deletion job per user.
  class PurgeExpiredJob < ApplicationJob
    queue_as :default

    def perform
      expired_onboarding_users.find_each do |user|
        PurgeAccountJob.perform_later(user)
      end
    end

    private

    # @return [ActiveRecord::Relation<User>] users pending onboarding with zero days remaining
    def expired_onboarding_users
      User.pending_onboarding.where(onboarding_days_remaining: 0)
    end
  end
end
