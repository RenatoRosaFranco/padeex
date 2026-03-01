# frozen_string_literal: true

class Dashboard::BaseController < ApplicationController
  include ReleasedAppGate

  before_action :authenticate_user!
  before_action :require_onboarding_completed!

  layout "dashboard"

  private

  def require_onboarding_completed!
    redirect_to edit_onboarding_personal_info_path unless current_user.onboarding_completed?
  end

  def require_club!
    redirect_to dashboard_path, alert: t("errors.club_required") unless current_user.club?
  end
end
