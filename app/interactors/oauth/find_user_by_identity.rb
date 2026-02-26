# frozen_string_literal: true

module Oauth
  # Looks up an existing user by OAuth provider + uid.
  # Read-only: no writes if user is found.
  class FindUserByIdentity
    include Interactor

    delegate :auth, to: :context

    def call
      context.user = UserIdentity.find_by(provider: auth.provider, uid: auth.uid)&.user
    end
  end
end
