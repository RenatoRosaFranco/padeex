# frozen_string_literal: true

module Resolvers
  module Oauth
    # Creates a new user and their first OAuth identity atomically.
    class CreateUserWithIdentity < BaseInteractor
      delegate :auth, to: :context

      # @param context [Interactor::Context] expects :auth
      # @return [void] sets context.user to the newly created User or nil
      def call
        return if email.blank?

        context.user = User.transaction do
          user = User.create!(
            email:    email,
            name:     name,
            password: SecureRandom.hex(32)
          )
          user.user_identities.create!(provider: auth.provider, uid: auth.uid)
          user
        end
      end

      private

      # @return [String, nil] email from OAuth provider
      def email
        auth.info&.email
      end

      # @return [String] name from OAuth provider, or derived from email, or "User"
      def name
        auth.info&.name.presence || email&.split("@")&.first || "User"
      end
    end
  end
end
