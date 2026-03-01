# frozen_string_literal: true

module Onboarding
  # Checks if a username is available for the current user.
  # Sets context.available (Boolean) and context.reason (:invalid when format/length invalid).
  #
  # @example
  #   result = Onboarding::CheckUsernameAvailability.call(username: "johndoe", current_user: user)
  #   result.available # => true/false
  #   result.reason    # => :invalid when username format invalid
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
      context.reason = nil
    end

    private

    def invalid_format?(str)
      str.length < 3 || !str.match?(/\A[a-z0-9._]+\z/)
    end
  end
end
