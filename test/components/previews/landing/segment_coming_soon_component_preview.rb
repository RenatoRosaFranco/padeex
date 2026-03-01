# @label Segment Coming Soon
# @logical_path landing/segment_coming_soon
class Landing::SegmentComingSoonComponentPreview < Lookbook::Preview
  layout "landing"

  # @label Atletas
  def athletes
    render Landing::SegmentComingSoonComponent.new(segment: "athletes")
  end

  # @label Clubes
  def clubs
    render Landing::SegmentComingSoonComponent.new(segment: "clubs")
  end

  # @label Empresas
  def companies
    render Landing::SegmentComingSoonComponent.new(segment: "companies")
  end

  # @label Investidores
  def investors
    render Landing::SegmentComingSoonComponent.new(segment: "investors")
  end
end
