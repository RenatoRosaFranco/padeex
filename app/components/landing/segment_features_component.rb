# frozen_string_literal: true

module Landing
  # Features section para landing pages segmentadas.
  class SegmentFeaturesComponent < ::ApplicationComponent
    # @param segment [String] Segment slug (athletes, clubs, companies).
    def initialize(segment:)
      @app_config = AppConfigService
      @content = SegmentContentService.fetch(segment)
    end

    # Returns features list from segment or app config. @return [Array]
    def features
      @content[:features] || @app_config.fetch(:features, default: [])
    end

    # Section eyebrow label from segment config. 
    # @return [String]
    def section_eyebrow
      @content[:section_eyebrow]
    end

    # Section headline from segment config.
    # @return [String]
    def section_headline
      @content[:section_headline]
    end

    # Section subtitle from segment config.
    # @return [String]
    def section_sub
      @content[:section_sub]
    end

    # Optional stats/metrics for investors. @return [Array, nil]
    def stats
      @content[:stats]
    end
  end
end
