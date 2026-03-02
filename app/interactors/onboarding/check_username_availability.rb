# frozen_string_literal: true

module Onboarding
  # Checks if a username is available for the current user.
  # Normalizes the input, validates format, and performs a DB lookup.
  #
  # This interactor always succeeds — it never calls fail_with!.
  # Read result.available, not result.success?, to determine availability.
  #
  # @example
  #   result = Onboarding::CheckUsernameAvailability.call(username: "johndoe", current_user: user)
  #   result.available # => true/false
  #   result.reason    # => :invalid when username format is invalid, nil otherwise
  class CheckUsernameAvailability < BaseInteractor
    delegate :username, :current_user, to: :context

    def call
      normalized = username.to_s.strip.downcase

      if invalid_format?(normalized)
        context.available = false
        context.reason = :invalid
        return
      end

      existing = UserProfile.where("LOWER(username) = ?", normalized).first
      context.available = existing.nil? || existing.user_id == current_user.id
    end

    private

    # @return [Boolean] true when length < 3 or contains invalid chars
    def invalid_format?(normalized)
      normalized.length < 3 || !normalized.match?(/\A[a-z0-9._]+\z/)
    end
  end
end
