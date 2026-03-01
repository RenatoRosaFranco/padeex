# frozen_string_literal: true

# Ensure the application locale is applied before Warden processes
# authentication failures, so Devise flash messages are translated.
Warden::Manager.before_failure do |env, _opts|
  I18n.locale = Rails.application.config.i18n.default_locale
end
