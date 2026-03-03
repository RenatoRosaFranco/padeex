require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

# Define Resolvers antes dos initializers (necessário para push_dir com namespace)
require File.expand_path("../lib/resolvers", __dir__)

module Padeex
  class Application < Rails::Application
    config.load_defaults 8.1

    # Exclui app/resolvers do autoload padrão (será carregado com namespace em initializers/resolvers.rb)
    excl = config.paths["app"].instance_variable_get(:@exclude) and excl << "resolvers"

    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.default_locale = :"pt-BR"
    config.i18n.available_locales = [:"pt-BR", :en]

    config.assets.paths << Rails.root.join("app/assets/builds")

    config.dartsass.builds = {
      "application.scss" => "application.css",
      "landing.scss"     => "landing.css",
      "auth.scss"        => "auth.css",
      "dashboard.scss"   => "dashboard.css",
      "onboarding.scss"  => "onboarding.css"
    }

    config.active_record.encryption.primary_key         = ENV.fetch("AR_ENCRYPTION_PRIMARY_KEY",        "M7e4SwDu3wQAI5BFGZc634z4t9L0ROMZ")
    config.active_record.encryption.deterministic_key   = ENV.fetch("AR_ENCRYPTION_DETERMINISTIC_KEY",  "iI03NQr27hzJfBsxEjYYm2CrSgdwK3pI")
    config.active_record.encryption.key_derivation_salt = ENV.fetch("AR_ENCRYPTION_KEY_DERIVATION_SALT", "kr9yzL1KeoDJupV23z77mBW3sAlpn1vd")
  end
end
