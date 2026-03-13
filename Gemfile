# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", "~> 8.1.2"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "dartsass-rails"
gem "image_processing", "~> 1.2"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

# Env vars
gem "dotenv-rails", groups: %i[development test]

# Email
gem "resend"

# Auth
gem "devise"
gem "devise-jwt"
gem "devise-two-factor"
gem "omniauth-google-oauth2"
gem "omniauth-facebook"
gem "omniauth-rails_csrf_protection"
gem "rqrcode"

# Search
gem "ransack"

# Storage AWS S3
gem "aws-sdk-s3"

# Friendly URLs (slugs)
gem "friendly_id", "~> 5.5"

# API serializers
gem "active_model_serializers", "~> 0.10"

# View components
gem "view_component"

# Presenters / Decorators
gem "draper"

# Paginação
gem "pagy"

# Feature flags
gem "flipper"

# OpenAI / ChatGPT
gem "openai"

# Error tracking
gem "sentry-rails"

# Interactors - encapsulamento de lógica de negócio
gem "interactor", "~> 3.0"
gem "interactor-rails", "~> 2.0"

# SMS
gem "twilio-ruby", "~> 7.0"

# Payments
gem "stripe",  "~> 12.0"
gem "faraday", "~> 2.0"
gem "flipper-active_record"
gem "flipper-ui"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false

  # N+1 detector
  gem "bullet"

  # Pretty print
  gem "awesome_print"

  # Dados falsos
  gem "faker"
  gem "ffaker"

  # Testes
  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails"
end

group :development do
  gem "rails_live_reload"
  gem "web-console"
  gem "rubocop-rails-omakase", require: false

  # Code quality
  gem "rails_best_practices", require: false
  gem "rubocop",              require: false
  gem "rubocop-rails",        require: false
  gem "rubocop-rspec",        require: false
  gem "rubocop-performance",  require: false
  gem "rubycritic",           require: false

  # Anotações de schema
  gem "annotate"

  # Diagrama ER
  gem "rails-erd"

  # Email no browser
  gem "letter_opener_web"

  # Component previews
  gem "lookbook"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 6.0"
  gem "database_cleaner-active_record"
  gem "simplecov", require: false
end
