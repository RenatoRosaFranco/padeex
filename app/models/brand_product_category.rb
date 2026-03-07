# frozen_string_literal: true

class BrandProductCategory < ApplicationRecord
  belongs_to :brand_profile
  has_many :products, class_name: "BrandProduct",
                      foreign_key: :brand_product_category_id,
                      dependent: :nullify

  validates :name,  presence: true
  validates :color, presence: true
  validates :icon,  presence: true
  validates :name,  uniqueness: { scope: :brand_profile_id, case_sensitive: false }

  scope :by_position, -> { order(position: :asc, name: :asc) }

  def self.with_active_products
    joins(:products).where(brand_products: { status: "active" }).distinct.by_position
  end

  def self.filter_options
    [ { key: "todos", label: "Todos" } ] +
      with_active_products.map { |c| { key: c.id.to_s, label: c.name } }
  end
end
