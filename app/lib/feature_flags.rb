# frozen_string_literal: true

module FeatureFlags
  # Central registry — add new flags here.
  # @return [Array<Symbol>]
  REGISTRY = %i[smart_assistant feed released_app store brand_released].freeze

  # @param flag [Symbol] Feature flag key from REGISTRY
  # @return [String] Localized description for the flag
  def self.description(flag)
    I18n.t("feature_flags.descriptions.#{flag}")
  end

  # @param flag [Symbol] Feature flag key from REGISTRY
  # @return [Boolean] Whether the flag is enabled (false on error)
  def self.enabled?(flag)
    Flipper.enabled?(flag)
  rescue StandardError
    false
  end
end
