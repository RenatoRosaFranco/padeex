# frozen_string_literal: true

# Configure Rails
Rails.application.configure do
end

# Configure Flipper
Flipper.configure do |config|
end

# Register all known feature flags from FeatureFlags::REGISTRY so Flipper
Rails.application.config.after_initialize do
  FeatureFlags::REGISTRY.each { |key| Flipper.add(key) }
rescue StandardError => e
  Rails.logger.warn("[FeatureFlags] Could not register flags: #{e.message}")
end
