# frozen_string_literal: true

module Oauth
  # Orchestrates OAuth user resolution in priority order:
  #   1. FindUserByIdentity     — lookup by provider+uid, no writes
  #   2. LinkIdentityToUser     — existing email, attach new provider
  #   3. CreateUserWithIdentity — first time, create user + identity
  class FindOrCreateUser < BaseInteractor
    delegate :auth, to: :context

    RESOLVERS = [
      Oauth::FindUserByIdentity,
      Oauth::LinkIdentityToUser,
      Oauth::CreateUserWithIdentity
    ].freeze

    def call
      RESOLVERS.each do |resolver|
        result = resolver.call(auth: auth)
        next unless result.user

        context.user = result.user
        return
      end

      context.fail!(error: "Invalid OAuth data")
    end
  end
end
