# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include ReleasedAppGate

  layout :choose_layout

  def new
    session[:referral_code] = params[:ref] if params[:ref].present?
    super
  end

  private

  def choose_layout
    action_name.in?(%w[edit update]) ? "dashboard" : "auth"
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :accepted_terms, :referred_by_code)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :mobile_number, :password, :password_confirmation, :current_password)
  end
end
