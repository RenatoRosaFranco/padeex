# frozen_string_literal: true

module Oauth
  # Finds or creates user from OAuth provider data.
  # @param auth [OmniAuth::AuthHash] OAuth callback data.
  class FindOrCreateUser < BaseInteractor
    delegate :auth, to: :context

    def call
      context.user = find_by_provider || find_by_email_and_link || create_user
      context.fail!(error: "Invalid OAuth data") unless context.user
    end

    private

    def find_by_provider
      User.find_by(provider: auth.provider, uid: auth.uid)
    end

    def find_by_email_and_link
      return unless email.present?

      user = User.find_by(email: email)
      return unless user

      user.update!(provider: auth.provider, uid: auth.uid)
      user
    end

    def create_user
      return unless email.present?

      User.create!(
        provider: auth.provider,
        uid: auth.uid,
        email: email,
        name: name,
        password: SecureRandom.hex(32)
      )
    end

    def email
      auth.info&.email
    end

    def name
      auth.info&.name.presence || email&.split("@")&.first || "User"
    end
  end
end
