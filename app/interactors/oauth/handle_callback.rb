# frozen_string_literal: true

module Oauth
  # Processes OAuth callback: finds or creates user from auth data.
  # @param auth [OmniAuth::AuthHash] OAuth callback data.
  # @param provider_name [String] Provider display name (e.g. "Google").
  class HandleCallback < BaseInteractor
    delegate :auth, to: :context

    def call
      context.user = User.from_omniauth(auth)
      context.fail!(error: "Invalid OAuth data") unless context.user
    end
  end
end
