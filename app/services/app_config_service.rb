# frozen_string_literal: true

# Service for reading app config from YAML file.
class AppConfigService
  PATH = Rails.root.join("data/app_config.yml")

  # Returns config value by key.
  # @param key [Symbol, String] Config key.
  # @param default [Object] Fallback when key missing.
  # @return [Object] Config value.
  def self.fetch(key, default: nil)
    config.fetch(key.to_sym, default)
  end

  # Loads and caches YAML config.
  # @return [Hash] Config with symbolized keys.
  def self.config
    @config ||= YAML.load_file(PATH, symbolize_names: true)
  end
  
  private_class_method :config
end

