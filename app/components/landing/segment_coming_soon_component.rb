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

    def coming_soon_headline
      @content[:coming_soon_headline].presence || "Algo grande está<br>chegando ao padel."
    end

    def coming_soon_sub
      @content[:coming_soon_sub].presence || "Estamos construindo o maior ecossistema de padel do Brasil. Seja um dos primeiros a saber quando abrirmos as portas."
    end

    def launch_chip
      @content[:launch_chip].presence || "Lançamento em breve"
    end
  end
end
