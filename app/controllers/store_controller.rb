# frozen_string_literal: true

class StoreController < ApplicationController
  layout "landing"

  before_action :require_store_flag
  before_action :find_product, only: [:show]

  def index
    @categories = StoreProductService::CATEGORIES
    @products   = StoreProductService.all
  end

  def show
    @related  = StoreProductService.all.select { |p| p.category == @product.category && p.id != @product.id }.first(4)
    @category = StoreProductService::CATEGORIES.find { |c| c[:key] == @product.category }
  end

  private

  # Loads product by id and redirects to store index when not found.
  # @return [void]
  def find_product
    @product = StoreProductService.find(params[:id])
    redirect_to loja_path unless @product
  end

  # Redirects to root when store feature flag is disabled.
  # @return [void]
  def require_store_flag
    redirect_to root_path unless FeatureFlags.enabled?(:store)
  end
end
