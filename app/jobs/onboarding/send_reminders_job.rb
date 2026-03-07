# frozen_string_literal: true

module Onboarding
  # Collects all pending users that still have days remaining and fans out
  # one email job per user. Using find_each keeps memory bounded regardless
  # of user volume.
  class SendRemindersJob < ApplicationJob
    queue_as :default

    def perform
      users_with_days_remaining.find_each do |user| 
        dispatch_reminder_for(user) 
      end
    end

    private

    # @return [ActiveRecord::Relation<User>] users pending onboarding with at least one day remaining
    def users_with_days_remaining
      User.pending_onboarding.where("onboarding_days_remaining > 0")
    end

    # @param user [User] the user to dispatch a reminder for
    def dispatch_reminder_for(user)
      if final_reminder?(user)
        SendFinalReminderJob.perform_later(user)
      else
        SendReminderJob.perform_later(user)
      end
    end

    # @param user [User]
    # @return [Boolean] true if user has exactly one day left (final reminder)
    def final_reminder?(user)
      user.onboarding_days_remaining == 1
    end
  end
end
