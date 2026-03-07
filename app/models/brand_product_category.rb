# frozen_string_literal: true

class BrandProductCategory < ApplicationRecord
  # Associations
  belongs_to :brand_profile
  has_many :products, class_name: "BrandProduct",
                      foreign_key: :brand_product_category_id,
                      dependent: :nullify

  # Validations
  validates :name,  presence: true
  validates :color, presence: true
  validates :icon,  presence: true
  validates :name,  uniqueness: { scope: :brand_profile_id, case_sensitive: false }

  # Scopes
  scope :by_position, -> { order(position: :asc, name: :asc) }

  # @return [ActiveRecord::Relation<BrandProductCategory>] categories with at least one active product, ordered by position
  def self.with_active_products
    joins(:products).where(brand_products: { status: "active" }).distinct.by_position
  end

  # @return [Array<Hash{Symbol => String}>] filter options (key, label) including "Todos" plus active categories
  def self.filter_options
    [ { key: "todos", label: "Todos" } ] +
      with_active_products.map { |c| { key: c.id.to_s, label: c.name } }
  end
end
