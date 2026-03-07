# frozen_string_literal: true

module Onboarding
  # Destroys a single user whose onboarding window expired.
  # Guard clause prevents deletion if onboarding was completed between
  # job enqueue and execution.
  # Discarded automatically by ApplicationJob if the user no longer exists.
  class PurgeAccountJob < ApplicationJob
    queue_as :default

    def perform(user)
      return if user.onboarding_completed?

      user.destroy!
    end
  end
end
