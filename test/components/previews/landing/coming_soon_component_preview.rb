# @label Coming Soon
# @logical_path landing/coming_soon
class Landing::ComingSoonComponentPreview < Lookbook::Preview
  layout "landing"

  # @label Default
  # Seção de lançamento em breve da landing page principal.
  def default
    render Landing::ComingSoonComponent.new
  end
end
