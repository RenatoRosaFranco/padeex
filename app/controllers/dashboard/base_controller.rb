# frozen_string_literal: true

class Dashboard::BaseController < ApplicationController
  include ReleasedAppGate

  before_action :authenticate_user!
  before_action :require_onboarding_completed!
  before_action :load_notifications

  layout "dashboard"

  private

  def require_onboarding_completed!
    redirect_to edit_onboarding_personal_info_path unless current_user.onboarding_completed?
  end

  def load_notifications
    @unread_notifications_count = current_user.notifications.unread.count
    @recent_notifications = current_user.notifications.recent.limit(8)
  end

  def require_club!
    redirect_to dashboard_path, alert: t("errors.club_required") unless current_user.club?
  end
end
