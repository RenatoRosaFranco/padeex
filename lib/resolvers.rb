# frozen_string_literal: true

# Defines the Resolvers namespace for app/resolvers.
# Loaded before the initializer that calls push_dir.
module Resolvers
  module Oauth
  end
end

# BaseInteractor must be loaded explicitly here because lib/resolvers.rb is required
# during early boot (before Zeitwerk autoloading is active).
require_relative "../app/interactors/base_interactor"

# Load resolvers (per-context implementations + list registry)
require_relative "../app/resolvers/oauth/find_user_by_identity"
require_relative "../app/resolvers/oauth/link_identity_to_user"
require_relative "../app/resolvers/oauth/create_user_with_identity"
require_relative "../app/resolvers/list"
