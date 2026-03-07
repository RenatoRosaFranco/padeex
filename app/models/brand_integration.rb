# frozen_string_literal: true

class BrandIntegration < ApplicationRecord
  PROVIDERS = %w[woocommerce prestashop vtext mercadolivre nuvemshop opencart olx custom].freeze

  PROVIDER_META = {
    "woocommerce"  => { label: "WooCommerce",    icon: "bi-cart4",             color: "#96588a" },
    "prestashop"   => { label: "PrestaShop",      icon: "bi-shop",              color: "#df0067" },
    "vtext"        => { label: "VText",           icon: "bi-chat-dots-fill",    color: "#2563eb" },
    "mercadolivre" => { label: "Mercado Livre",   icon: "bi-bag-fill",          color: "#ffe600" },
    "nuvemshop"    => { label: "Nuvemshop",       icon: "bi-cloud-fill",        color: "#0084ff" },
    "opencart"     => { label: "OpenCart",        icon: "bi-cart-check-fill",   color: "#43ac2c" },
    "olx"          => { label: "OLX",             icon: "bi-megaphone-fill",    color: "#e37422" },
    "custom"       => { label: "Personalizado",   icon: "bi-plug-fill",         color: "#6b7280" }
  }.freeze

  belongs_to :brand_profile

  enum :status, { inactive: "inactive", active: "active" }

  validates :provider, inclusion: { in: PROVIDERS }, uniqueness: { scope: :brand_profile_id }

  def meta
    PROVIDER_META.fetch(provider, PROVIDER_META["custom"])
  end

  def display_label
    label.presence || meta[:label]
  end
end
