# frozen_string_literal: true

# Verifies reCAPTCHA v3 token with Google API.
#
# @example
#   RecaptchaVerifyService.call(token: params[:recaptcha_token], remote_ip: request.remote_ip)
class RecaptchaVerifyService
  # reCAPTCHA verification URL
  VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify"
  # Minimum score required for the token to be considered valid
  MIN_SCORE = 0.5

  # @param token [String] reCAPTCHA v3 token from the client
  # @param remote_ip [String] user IP address (optional)
  # @return [Boolean] true when Google confirms the token and score meets MIN_SCORE
  def self.call(token:, remote_ip: nil)
    new(token: token, remote_ip: remote_ip).call
  end

  def initialize(token:, remote_ip: nil)
    @token = token
    @remote_ip = remote_ip
  end

  def call
    return false if @token.blank?

    data = fetch_verification
    data["success"] && (data["score"] || 0) >= MIN_SCORE
  rescue StandardError => e
    Rails.logger.error "[Recaptcha] Verification error: #{e.message}"
    false
  end

  private

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
