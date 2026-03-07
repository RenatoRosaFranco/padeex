# frozen_string_literal: true

class BrandProduct < ApplicationRecord
  # Associations
  belongs_to :brand_profile
  belongs_to :brand_product_category, optional: true

  # Attachments
  has_one_attached :image

  # Enums
  enum :status, { draft: "draft", active: "active", archived: "archived" }

  # Validations
  validates :name,        presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :status,      inclusion: { in: statuses.keys }

  # Scopes
  scope :by_position, -> { order(position: :asc, created_at: :desc) }

  # @return [Float] price in reais (price_cents / 100)
  def price
    price_cents / 100.0
  end

  # @return [String] price formatted as Brazilian Real (e.g. "R$ 10,50")
  def price_brl
    format("R$ %<price>.2f", price: price_cents / 100.0).gsub(".", ",")
  end

  # @return [String] category color hex or default "#3628c5"
  def category_color
    brand_product_category&.color || "#3628c5"
  end

  # @return [String] category icon or default "box-fill"
  def category_icon
    brand_product_category&.icon  || "box-fill"
  end

  # @return [String] category name or default "—"
  def category_label
    brand_product_category&.name  || "—"
  end
end
