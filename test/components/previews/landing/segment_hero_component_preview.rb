# @label Segment Hero
# @logical_path landing/segment_hero
class Landing::SegmentHeroComponentPreview < Lookbook::Preview
  layout "landing"

  # @label Atletas
  def athletes
    render Landing::SegmentHeroComponent.new(segment: "athletes")
  end

  # @label Clubes
  def clubs
    render Landing::SegmentHeroComponent.new(segment: "clubs")
  end

  # @label Empresas
  def companies
    render Landing::SegmentHeroComponent.new(segment: "companies")
  end

  # @label Investidores
  def investors
    render Landing::SegmentHeroComponent.new(segment: "investors")
  end
end
