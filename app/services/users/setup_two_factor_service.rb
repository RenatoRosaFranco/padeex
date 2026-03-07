# frozen_string_literal: true

module Users
  # Generates OTP secret, provisioning URI, and QR code SVG for 2FA setup.
  # Used when starting setup or re-rendering the form after validation failure.
  #
  # @example
  #   result = Users::SetupTwoFactorService.call(user: current_user)
  #   session[:otp_setup_secret] = result[:otp_secret]
  #   @otp_secret = result[:otp_secret]
  #   @provisioning_uri = result[:provisioning_uri]
  #   @qr_svg = result[:qr_svg]
  class SetupTwoFactorService < ApplicationService
    # Constants
    ISSUER = "Padex"

    QR_OPTIONS = {
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    }.freeze

    # @param user [User]
    # @param otp_secret [String, nil] optional; use existing secret when re-rendering after validation failure
    def initialize(user:, otp_secret: nil)
      @user       = user
      @otp_secret = otp_secret || User.generate_otp_secret
    end

    # Returns OTP setup data for the view.
    #
    # @return [Hash] { otp_secret:, provisioning_uri:, qr_svg: }
    def call
      provisioning_uri = @user.otp_provisioning_uri(
        @user.email,
        otp_secret: @otp_secret,
        issuer: ISSUER
      )
      qr_svg = RQRCode::QRCode.new(provisioning_uri).as_svg(**QR_OPTIONS)

      {
        otp_secret:       @otp_secret,
        provisioning_uri: provisioning_uri,
        qr_svg:          qr_svg
      }
    end
  end
end
