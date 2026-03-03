# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include ReleasedAppGate

  layout "auth"

  skip_before_action :require_app_released!, only: [:destroy]

  def create
    user = User.find_by(email: resource_params[:email].to_s.downcase.strip)

    result = Users::RequireOtpVerificationService.call(
      user:         user,
      password:     resource_params[:password],
      otp_attempt:  resource_params[:otp_attempt],
      remember_me:  resource_params[:remember_me]
    )

    if result
      session[:otp_user_id] = result[:user_id]
      session[:otp_user_remember_me] = result[:remember_me]
      redirect_to new_user_two_factor_path and return
    end

    super
  end

  private

  def resource_params
    params.require(:user).permit(:email, :password, :remember_me, :otp_attempt)
  end
end
