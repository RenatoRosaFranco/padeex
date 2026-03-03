# frozen_string_literal: true

class Users::TwoFactorController < ApplicationController
  layout "auth"

  before_action :require_pending_otp_user

  def new
  end

  def create
    user = User.find(session[:otp_user_id])
    result = Users::VerifyOtpService.call(user: user, otp_attempt: params[:otp_attempt])

    if result[:success]
      remember_me = session.delete(:otp_user_remember_me) == "1"
      session.delete(:otp_user_id)
      sign_in(:user, user, remember: remember_me)
      redirect_to after_sign_in_path_for(user)
    else
      flash.now[:alert] = result[:alert]
      render :new, status: :unprocessable_entity
    end
  end

  private

  def require_pending_otp_user
    redirect_to new_user_session_path unless session[:otp_user_id]
  end
end
