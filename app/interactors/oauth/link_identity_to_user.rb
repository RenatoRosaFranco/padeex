# frozen_string_literal: true

module Oauth
  # Finds an existing user by email and attaches the new OAuth identity.
  # Handles the case where the same email is used across multiple providers.
  class LinkIdentityToUser
    include Interactor

    delegate :auth, to: :context

    def call
      return unless email.present?

      user = User.find_by(email: email)
      return unless user

      user.user_identities.find_or_create_by!(provider: auth.provider, uid: auth.uid)
      context.user = user
    end

    private

    def email
      auth.info&.email
    end
  end
end
