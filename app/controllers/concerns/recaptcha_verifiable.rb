# frozen_string_literal: true

# Verifies reCAPTCHA v3 token on the backend to block fake requests (Postman, Insomnia, etc).
# Configure RECAPTCHA_SITE_KEY and RECAPTCHA_SECRET_KEY in .env.
# Verification is skipped when keys are not set (useful for dev/test).
#
# @example Usage in controller
#   include RecaptchaVerifiable
#   verify_recaptcha only: [:create]
module RecaptchaVerifiable
  extend ActiveSupport::Concern

  class_methods do
    def verify_recaptcha(options = {})
      before_action :recaptcha_verify!, options.merge(if: :recaptcha_verification_enabled?)
    end
  end

  private

  # @return [Boolean] true when RECAPTCHA_SECRET_KEY is set and verification should run
  def recaptcha_verification_enabled?
    ENV["RECAPTCHA_SECRET_KEY"].present?
  end

  # Verifies the recaptcha_token param with Google API. Responds with 403 Forbidden when invalid.
  # @return [void]
  def recaptcha_verify!
    token = params[:recaptcha_token]
    return head :forbidden if token.blank?

    unless recaptcha_valid?(token)
      Rails.logger.warn "[Recaptcha] Verification failed - possible fake request"
      head :forbidden
    end
  end

  # @param token [String] reCAPTCHA v3 token from the client
  # @return [Boolean] true when Google confirms the token and score meets MIN_SCORE
  def recaptcha_valid?(token)
    RecaptchaVerifyService.call(token: token, remote_ip: request.remote_ip)
  end
end
