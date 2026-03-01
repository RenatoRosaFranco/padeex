# @label Segment Features
# @logical_path landing/segment_features
class Landing::SegmentFeaturesComponentPreview < Lookbook::Preview
  layout "landing"

  # @label Atletas
  def athletes
    render Landing::SegmentFeaturesComponent.new(segment: "athletes")
  end

  # @label Clubes
  def clubs
    render Landing::SegmentFeaturesComponent.new(segment: "clubs")
  end

  # @label Empresas
  def companies
    render Landing::SegmentFeaturesComponent.new(segment: "companies")
  end

  # @label Investidores
  def investors
    render Landing::SegmentFeaturesComponent.new(segment: "investors")
  end
end
