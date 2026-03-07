# frozen_string_literal: true

class Dashboard::Brands::IntegrationsController < Dashboard::Brands::BaseController
  before_action :require_brand_profile!
  before_action :set_integration, only: [:update, :destroy]

  def index
    if current_brand_profile
      connected = current_brand_profile.integrations.index_by(&:provider)
      @integrations = BrandIntegration::PROVIDERS.map do |provider|
        connected[provider] || current_brand_profile.integrations.new(provider: provider)
      end
    else
      @integrations = BrandIntegration.all.order(provider: :asc)
      @admin_view = true
    end
  end

  def create
    return redirect_to dashboard_brands_integrations_path, alert: "Admin sem brand_profile não pode criar integrações." unless current_brand_profile
    result = Actions::Create.call(scope: current_brand_profile.integrations, attributes: integration_params)
    if result.success?
      redirect_to dashboard_brands_integrations_path, notice: t("flash.brand_integration.connected", label: result.record.display_label)
    else
      redirect_to dashboard_brands_integrations_path, alert: result.record.errors.full_messages.first
    end
  end

  def update
    result = Actions::Update.call(record: @integration, attributes: integration_params)
    if result.success?
      redirect_to dashboard_brands_integrations_path, notice: t("flash.brand_integration.updated", label: @integration.display_label)
    else
      redirect_to dashboard_brands_integrations_path, alert: result.record.errors.full_messages.first
    end
  end

  def destroy
    Actions::Remove.call(record: @integration)
    redirect_to dashboard_brands_integrations_path, notice: t("flash.brand_integration.disconnected")
  end

  private

  def set_integration
    @integration = current_brand_profile.integrations.find(params[:id])
  end

  def require_brand_profile!
    return if current_user.admin?
    redirect_to dashboard_path, alert: t("errors.brand_required") unless current_brand_profile
  end

  def integration_params
    params.require(:brand_integration).permit(:provider, :label, :store_url, :api_key, :status)
  end
end
