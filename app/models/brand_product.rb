# frozen_string_literal: true

class BrandProduct < ApplicationRecord
  belongs_to :brand_profile
  belongs_to :brand_product_category, optional: true

  has_one_attached :image

  enum :status, { draft: "draft", active: "active", archived: "archived" }

  validates :name,        presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :status,      inclusion: { in: statuses.keys }

  scope :by_position, -> { order(position: :asc, created_at: :desc) }

  def price
    price_cents / 100.0
  end

  def price_brl
    format("R$ %<price>.2f", price: price_cents / 100.0).gsub(".", ",")
  end

  def category_color = brand_product_category&.color || "#3628c5"
  def category_icon  = brand_product_category&.icon  || "box-fill"
  def category_label = brand_product_category&.name  || "—"
end
