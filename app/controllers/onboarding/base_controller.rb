# frozen_string_literal: true

class Onboarding::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_completed

  layout "onboarding"

  private

  def redirect_if_completed
    redirect_to dashboard_path if current_user.onboarding_completed?
  end
end
