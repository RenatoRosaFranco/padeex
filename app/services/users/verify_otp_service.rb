# frozen_string_literal: true

module Users
  # Validates OTP attempt for a user pending 2FA verification.
  # Consumes the OTP on success (one-time use).
  #
  # @example
  #   result = Users::VerifyOtpService.call(user: user, otp_attempt: params[:otp_attempt])
  #   if result[:success]
  #     sign_in(:user, user, remember: session[:otp_user_remember_me] == "1")
  #     redirect_to after_sign_in_path_for(user)
  #   else
  #     flash.now[:alert] = result[:alert]
  #     render :new, status: :unprocessable_entity
  #   end
  class VerifyOtpService < ApplicationService
    # @param user [User]
    # @param otp_attempt [String]
    def initialize(user:, otp_attempt:)
      @user        = user
      @otp_attempt = otp_attempt.to_s.strip
    end

    # Validates and consumes OTP. Returns success flag and optional alert message.
    #
    # @return [Hash] { success: Boolean, alert: String (on failure) }
    def call
      if @user.validate_and_consume_otp!(@otp_attempt)
        { success: true }
      else
        { success: false, alert: I18n.t("users.two_factor.invalid_otp") }
      end
    end
  end
end
