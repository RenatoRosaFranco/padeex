# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include ReleasedAppGate

  layout "auth"

  private

  # Permitted params for sign up.
  # @return [ActionController::Parameters] Permitted params for sign up.
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Permitted params for account update.
  # @return [ActionController::Parameters] Permitted params for account update.
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end
