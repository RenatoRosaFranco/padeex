# frozen_string_literal: true

module Oauth
  # Creates a new user and their first OAuth identity atomically.
  class CreateUserWithIdentity
    include Interactor

    delegate :auth, to: :context

    def call
      return unless email.present?

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

    def email
      auth.info&.email
    end

    def name
      auth.info&.name.presence || email&.split("@")&.first || "User"
    end
  end
end
