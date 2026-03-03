# frozen_string_literal: true

module Users
  # Checks if user with 2FA enabled has valid password but no OTP yet.
  # Returns session data to store before redirecting to OTP verification page.
  #
  # @example
  #   result = Users::RequireOtpVerificationService.call(
  #     user: user,
  #     password: params[:password],
  #     otp_attempt: params[:otp_attempt],
  #     remember_me: params[:remember_me]
  #   )
  #   if result
  #     session[:otp_user_id] = result[:user_id]
  #     session[:otp_user_remember_me] = result[:remember_me]
  #     redirect_to new_user_two_factor_path
  #   else
  #     # proceed with normal sign in
  #   end
  class RequireOtpVerificationService < ApplicationService
    # @param user [User, nil]
    # @param password [String]
    # @param otp_attempt [String]
    # @param remember_me [String]
    def initialize(user:, password:, otp_attempt:, remember_me:)
      @user         = user
      @password     = password
      @otp_attempt  = otp_attempt
      @remember_me  = remember_me
    end

    # Returns session data when user must complete OTP verification, nil otherwise.
    #
    # @return [Hash, nil] { user_id:, remember_me: } or nil
    def call
      return nil unless @user&.otp_required_for_login
      return nil if @otp_attempt.present?
      return nil unless @user.valid_password?(@password)

      { user_id: @user.id, remember_me: @remember_me }
    end
  end
end
