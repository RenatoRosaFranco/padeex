# frozen_string_literal: true

class BrandIntegration < ApplicationRecord
  PROVIDER_META = YAML.load_file(Rails.root.join("data/brand_integrations/providers.yml"))
                      .transform_values(&:symbolize_keys).freeze

  PROVIDERS = PROVIDER_META.keys.freeze

  # Associations
  belongs_to :brand_profile

  # Enums
  enum :status, { inactive: "inactive", active: "active" }

  # Validations
  validates :provider, inclusion: { in: PROVIDERS }, uniqueness: { scope: :brand_profile_id }

  def meta
    PROVIDER_META.fetch(provider, PROVIDER_META["custom"])
  end

  def display_label
    label.presence || meta[:label]
  end
end
