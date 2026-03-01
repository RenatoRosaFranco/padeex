# frozen_string_literal: true

module Landing
  # Hero section for segmented landing pages (athletes, clubs, companies).
  class SegmentHeroComponent < ::ApplicationComponent
    # @param segment [String] Segment slug (athletes, clubs, companies).
    def initialize(segment:)
      @segment = segment
      @content = SegmentContentService.fetch(segment, tenant: Current.tenant)
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
