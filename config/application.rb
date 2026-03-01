require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Padeex
  class Application < Rails::Application
    config.load_defaults 8.1

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
  end
end
