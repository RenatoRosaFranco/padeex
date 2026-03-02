# frozen_string_literal: true

require "net/http"
require "json"

# Verifies reCAPTCHA v3 token with Google API.
#
# @example
#   RecaptchaVerifyService.call(token: params[:recaptcha_token], remote_ip: request.remote_ip)
class RecaptchaVerifyService < ApplicationService
  # reCAPTCHA verification URL
  VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify"
  # Minimum score required for the token to be considered valid
  MIN_SCORE = 0.5

  # @param token [String] reCAPTCHA v3 token from the client
  # @param remote_ip [String, nil] user IP address (optional)
  def initialize(token:, remote_ip: nil)
    @token = token
    @remote_ip = remote_ip
  end

  # Verifies token with Google API and checks score against MIN_SCORE.
  # @return [Boolean] true when verification succeeds and score meets threshold
  def call
    return false if @token.blank?

    data = fetch_verification
    data["success"] && (data["score"] || 0) >= MIN_SCORE
  rescue StandardError => e
    Rails.logger.error "[Recaptcha] Verification error: #{e.message}"
    false
  end

  private

  # @return [Hash] Google API response (success, score, action, etc.)
  def fetch_verification
    uri = URI(VERIFY_URL)
    res = Net::HTTP.post_form(uri, {
      secret: ENV["RECAPTCHA_SECRET_KEY"],
      response: @token,
      remoteip: @remote_ip
    })
    JSON.parse(res.body)
  end
end
