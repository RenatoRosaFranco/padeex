# frozen_string_literal: true

module Landing
  # Hero section para landing pages segmentadas (atletas, clubes, empresas).
  class SegmentHeroComponent < ::ApplicationComponent
    # @param segment [String] Segment slug (atletas, clubes, empresas).
    def initialize(segment:)
      @segment = segment
      @content = SegmentContentService.fetch(segment)
    end

    # Returns hero content for the segment.
    # @return [Hash] Hero content.
    def hero
      @content.dig(:hero)
    end

    # Returns feature tags for the segment.
    # @return [Array] Feature tags.
    def feature_tags
      @content[:feature_tags]
    end

    # Optional custom CTA button text (e.g. "Quero investir").
    # @return [String]
    def cta_button_text
      @content[:hero_cta_button].presence || "Entrar na lista"
    end
  end
end
