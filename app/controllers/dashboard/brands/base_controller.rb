# frozen_string_literal: true

class Dashboard::Brands::BaseController < Dashboard::BaseController
  include Pagy::Method

  before_action :require_brand_released!
  before_action :require_brand!

  helper_method :current_brand_profile

  private

  def require_brand_released!
    redirect_to dashboard_path unless FeatureFlags.enabled?(:brand_released)
  end

  def require_brand!
    redirect_to dashboard_path, alert: t("errors.brand_required") unless current_user.brand? || current_user.admin?
  end

  def current_brand_profile
    current_user.brand_profile
  end
end
