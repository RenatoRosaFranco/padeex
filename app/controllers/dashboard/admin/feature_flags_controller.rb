# frozen_string_literal: true

class Dashboard::Admin::FeatureFlagsController < Dashboard::Admin::BaseController
  def index
    @flags = FeatureFlags::REGISTRY.map do |key, description|
      { key: key, description: description, enabled: Flipper.enabled?(key) }
    end
  end

  def toggle
    key = params[:key].to_sym
    return head :bad_request unless FeatureFlags::REGISTRY.key?(key)

    Flipper.enabled?(key) ? Flipper.disable(key) : Flipper.enable(key)

    status = Flipper.enabled?(key) ? :enabled : :disabled
    redirect_to dashboard_admin_feature_flags_path,
                notice: t("flash.feature_flag.#{status}", key: key)
  end
end
