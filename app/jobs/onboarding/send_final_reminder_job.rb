# frozen_string_literal: true

module Onboarding
  # Delivers the final reminder email (1 day left) to a single user,
  # informing them that their account will be deleted if onboarding is not completed.
  # Discarded automatically by ApplicationJob if the user no longer exists.
  class SendFinalReminderJob < ApplicationJob
    queue_as :mailers

    def perform(user)
      return if user.onboarding_completed?

      deliver_final_reminder(user)
    end

    private

    # @param user [User] the user to deliver the final reminder to
    # @return [Mail::Message] the delivered mail message
    def deliver_final_reminder(user)
      UserMailer.onboarding_final_reminder(user).deliver_now
    end
  end
end
