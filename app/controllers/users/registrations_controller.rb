# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include ReleasedAppGate

  layout :choose_layout

  private

  def choose_layout
    action_name.in?(%w[edit update]) ? "dashboard" : "auth"
  end

  # Permitted params for sign up.
  # @return [ActionController::Parameters] Permitted params for sign up.
  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :accepted_terms)
  end

  # Permitted params for account update.
  # @return [ActionController::Parameters] Permitted params for account update.
  def account_update_params
    params.require(:user).permit(:name, :email, :mobile_number, :password, :password_confirmation, :current_password)
  end
end
