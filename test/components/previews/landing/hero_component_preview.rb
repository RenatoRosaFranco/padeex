# @label Hero
# @logical_path landing/hero
class Landing::HeroComponentPreview < Lookbook::Preview
  layout "landing"

  # @label Default
  # Seção hero da landing page principal com navbar, CTA e tags de features.
  def default
    render Landing::HeroComponent.new
  end
end
