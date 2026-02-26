# frozen_string_literal: true

# Landing page components.
module Landing
  # Coming soon section para landing pages segmentadas.
  class SegmentComingSoonComponent < ::ApplicationComponent

    # @param segment [String] Segment slug (athletes, clubs, companies).
    # @return [SegmentContentService] Segment content service.
    def initialize(segment:)
      @content = SegmentContentService.fetch(segment)
    end

    # CTA hint from segment config.
    # @return [String]
    def cta_hint
      @content[:cta_hint]
    end
  end
end
