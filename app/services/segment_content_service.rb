# frozen_string_literal: true

# Carrega conteúdo das landing pages segmentadas.
class SegmentContentService
  PATH = Rails.root.join("data/segment_content.yml")

  # Returns content for a given slug.
  # @param slug [String] Slug of the segment.
  # @return [Hash] Content for the segment.
  def self.fetch(slug)
    key = slug.to_s.presence&.to_sym
    config[key] || config[:default] || {}
  end

  # Loads and caches YAML config.
  # @return [Hash] Config with symbolized keys.
  def self.config
    @config ||= YAML.load_file(PATH, symbolize_names: true) || {}
  end

  private_class_method :config
end
