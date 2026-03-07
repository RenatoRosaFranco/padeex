# frozen_string_literal: true

class Dashboard::Brands::ProductsController < Dashboard::Brands::BaseController
  before_action :require_brand_profile!
  before_action :set_product, only: [:edit, :update, :destroy]

  def index
    @pagy, @products = pagy(:offset, product_scope.by_position, limit: 12)
  end

  def new
    @product = product_scope.new
  end

  def create
    result = Actions::Create.call(scope: product_scope, attributes: product_params)
    if result.success?
      redirect_to dashboard_brands_products_path, notice: t("flash.brand_product.created", name: result.record.name)
    else
      @product = result.record
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    result = Actions::Update.call(record: @product, attributes: product_params)
    if result.success?
      redirect_to dashboard_brands_products_path, notice: t("flash.brand_product.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Actions::Remove.call(record: @product)
    redirect_to dashboard_brands_products_path, notice: t("flash.brand_product.removed")
  end

  private

  def product_scope
    current_brand_profile ? current_brand_profile.products : BrandProduct.all
  end

  def set_product
    result = Actions::Find.call(scope: product_scope, id: params[:id])
    result.success? ? (@product = result.record) : redirect_to(dashboard_brands_products_path, alert: t("errors.not_found"))
  end

  def require_brand_profile!
    return if current_user.admin?
    redirect_to dashboard_path, alert: t("errors.brand_required") unless current_brand_profile
  end

  def product_params
    p = params.require(:brand_product).permit(:name, :description, :price_cents, :brand_product_category_id, :status, :external_url, :position, :image)
    p[:price_cents] = (p[:price_cents].to_s.gsub(",", ".").to_f * 100).round if p[:price_cents].present?
    p
  end
end
