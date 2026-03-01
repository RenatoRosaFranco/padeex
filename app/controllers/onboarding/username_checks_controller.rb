# frozen_string_literal: true

class Onboarding::UsernameChecksController < ApplicationController
  before_action :authenticate_user!

  def show
    result = Onboarding::CheckUsernameAvailability.call(
      username: params[:username],
      current_user: current_user
    )

    render json: { available: result.available, reason: result.reason }
  end
end
