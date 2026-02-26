# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include ReleasedAppGate

  layout "auth"

  # Skip the gate for sign_out so users can always log out
  skip_before_action :require_app_released!, only: [:destroy]
end
