# frozen_string_literal: true

module Resolvers
  module Oauth
    # Looks up an existing user by OAuth provider + uid.
    # Read-only: no writes if user is found.
    class FindUserByIdentity < BaseInteractor
      delegate :auth, to: :context

      # @param context [Interactor::Context] expects :auth
      # @return [void] sets context.user to the matched User or nil
      def call
        context.user = UserIdentity.find_by(provider: auth.provider, uid: auth.uid)&.user
      end
    end
  end
end
