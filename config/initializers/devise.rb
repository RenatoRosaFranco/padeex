# frozen_string_literal: true

Devise.setup do |config|
  config.mailer_sender = "noreply@padeex.com.br"

  require "devise/orm/active_record"

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  if ENV["GOOGLE_CLIENT_ID"].present?
    config.omniauth :google_oauth2,
      ENV["GOOGLE_CLIENT_ID"],
      ENV["GOOGLE_CLIENT_SECRET"],
      scope: "email,profile"
  end

  if ENV["FACEBOOK_APP_ID"].present?
    config.omniauth :facebook,
      ENV["FACEBOOK_APP_ID"],
      ENV["FACEBOOK_APP_SECRET"],
      scope: "email,public_profile"
  end

  config.warden do |manager|
    manager.failure_app = ApiFailureApp
  end

  # JWT for API authentication
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.secret_key_base
    jwt.expiration_time = 24.hours.to_i
    jwt.dispatch_requests = [
      ["POST", %r{^/api/v1/auth/sign_in$}]
    ]
    jwt.revocation_requests = [
      ["DELETE", %r{^/api/v1/auth/sign_out$}]
    ]
  end
end
