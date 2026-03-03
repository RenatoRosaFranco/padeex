# frozen_string_literal: true

class Dashboard::TwoFactorController < Dashboard::BaseController
  def show
  end

  def new
    result = Users::SetupTwoFactorService.call(user: current_user)
    session[:otp_setup_secret] = result[:otp_secret]
    @otp_secret = result[:otp_secret]
    @provisioning_uri = result[:provisioning_uri]
    @qr_svg = result[:qr_svg]
  end

  def create
    otp_secret = session[:otp_setup_secret]

    unless otp_secret.present?
      redirect_to new_dashboard_two_factor_path, alert: I18n.t("users.two_factor.session_expired")
      return
    end

    if current_user.validate_and_consume_otp!(params[:otp_attempt].to_s.strip, otp_secret: otp_secret)
      session.delete(:otp_setup_secret)
      current_user.update!(otp_secret: otp_secret, otp_required_for_login: true)

      redirect_to dashboard_two_factor_path, notice: I18n.t("users.two_factor.enabled_success")
    else
      flash.now[:alert] = I18n.t("users.two_factor.invalid_setup_code")
      result = Users::SetupTwoFactorService.call(user: current_user, otp_secret: otp_secret)
      
      @otp_secret = result[:otp_secret]
      @provisioning_uri = result[:provisioning_uri]
      @qr_svg = result[:qr_svg]

      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.update!(otp_required_for_login: false, otp_secret: nil, consumed_timestep: nil)
    redirect_to dashboard_two_factor_path, notice: I18n.t("users.two_factor.disabled")
  end
end
