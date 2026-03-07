# frozen_string_literal: true

class StoreController < ApplicationController
  layout "landing"

  before_action :require_store_flag
  before_action :find_product, only: [:show]

  def index
    @categories = BrandProductCategory.filter_options
    @products   = BrandProduct.active.by_position.includes(:brand_profile, :brand_product_category)
  end

  def show
    @related = BrandProduct.active
                            .where(brand_product_category_id: @product.brand_product_category_id)
                            .where.not(id: @product.id)
                            .by_position
                            .includes(:brand_profile, :brand_product_category)
                            .limit(4)
  end

  private

  def find_product
    @product = BrandProduct.active
                            .includes(:brand_profile, :brand_product_category)
                            .find_by(id: params[:id])
    redirect_to loja_path unless @product
  end

  def require_store_flag
    redirect_to root_path unless FeatureFlags.enabled?(:store)
  end
end
