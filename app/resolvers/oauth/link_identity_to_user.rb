# frozen_string_literal: true

module Resolvers
  module Oauth
    # Finds an existing user by email and attaches the new OAuth identity.
    # Handles the case where the same email is used across multiple providers.
    class LinkIdentityToUser < BaseInteractor
      delegate :auth, to: :context

      # @param context [Interactor::Context] expects :auth
      # @return [void] sets context.user to the matched User or nil
      def call
        return if email.blank?

        user = User.find_by(email: email)
        return unless user

        user.user_identities.find_or_create_by!(provider: auth.provider, uid: auth.uid)
        context.user = user
      end

      private

      # @return [String, nil] email from OAuth provider
      def email
        auth.info&.email
      end
    end
  end
end
