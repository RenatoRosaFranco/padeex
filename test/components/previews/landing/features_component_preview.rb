# @label Features
# @logical_path landing/features
class Landing::FeaturesComponentPreview < Lookbook::Preview
  layout "landing"

  # @label Default
  # Seção de features da landing page principal.
  def default
    render Landing::FeaturesComponent.new
  end
end
