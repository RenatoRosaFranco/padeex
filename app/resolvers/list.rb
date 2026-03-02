# frozen_string_literal: true

module Resolvers
  # Resolver registry by context.
  # @example Access by name
  #   Resolvers::Oauth.resolvers[:find_user_by_identity]
  # @example Priority order
  #   Resolvers::Oauth.list
  # @return [Hash{Symbol => Hash{Symbol => Class}}]
  LIST = {
    oauth: {
      find_user_by_identity: Oauth::FindUserByIdentity,
      link_identity_to_user: Oauth::LinkIdentityToUser,
      create_user_with_identity: Oauth::CreateUserWithIdentity
    }
  }.freeze

  module Oauth
    # @return [Array<Class>] OAuth resolvers in priority order for FindOrCreateUser
    def self.list
      LIST[:oauth].values.freeze
    end

    # @return [Hash{Symbol => Class}] Name => class map of OAuth resolvers
    def self.resolvers
      LIST[:oauth].freeze
    end
  end
end
