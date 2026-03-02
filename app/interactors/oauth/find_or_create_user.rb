# frozen_string_literal: true

module Oauth
  # Orchestrates OAuth user resolution in priority order:
  #   1. FindUserByIdentity     — lookup by provider+uid, no writes
  #   2. LinkIdentityToUser     — existing email, attach new provider
  #   3. CreateUserWithIdentity — first time, create user + identity
  class FindOrCreateUser < BaseInteractor
    delegate :auth, to: :context

    def call
      context.user = resolve_user
      fail_with!(error: I18n.t("oauth.invalid_data")) unless context.user
    end

    private

    # Tries each resolver in priority order and returns the first user found.
    # @return [User, nil]
    def resolve_user
      Resolvers::Oauth.list.each do |resolver|
        result = resolver.call(auth: auth)
        return result.user if result.user
      end
      nil
    end
  end
end
