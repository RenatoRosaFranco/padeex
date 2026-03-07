# frozen_string_literal: true

module Onboarding
  # Delivers the daily onboarding reminder email to a single user.
  # Discarded automatically by ApplicationJob if the user no longer exists.
  class SendReminderJob < ApplicationJob
    queue_as :mailers

    def perform(user)
      return if user.onboarding_completed?

      deliver_reminder(user)
    end

    private

    # @param user [User] the user to deliver the reminder to
    # @return [Mail::Message] the delivered mail message
    def deliver_reminder(user)
      UserMailer.onboarding_reminder(user).deliver_now
    end
  end
end
