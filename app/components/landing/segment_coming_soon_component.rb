# frozen_string_literal: true

# Landing page components.
module Landing
  # Coming soon section for segmented landing pages.
  class SegmentComingSoonComponent < ::ApplicationComponent

    # @param segment [String] Segment slug (athletes, clubs, companies).
    # @return [SegmentContentService] Segment content service.
    def initialize(segment:)
      @content = SegmentContentService.fetch(segment, tenant: Current.tenant)
    end

    # CTA hint from segment config.
    # @return [String]
    def cta_hint
      @content[:cta_hint]
    end

    # @return [String, nil] coming soon headline from segment config
    def coming_soon_headline
      @content[:coming_soon_headline]
    end

    # @return [String, nil] coming soon subtitle from segment config
    def coming_soon_sub
      @content[:coming_soon_sub]
    end

    # @return [String, nil] launch chip label from segment config
    def launch_chip
      @content[:launch_chip]
    end
  end
end
