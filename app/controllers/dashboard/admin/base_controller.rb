# frozen_string_literal: true

class Dashboard::Admin::BaseController < Dashboard::BaseController
  before_action :require_admin!

  private

  def require_admin!
    redirect_to dashboard_path, alert: t("errors.admin_required") unless current_user.admin?
  end
end
