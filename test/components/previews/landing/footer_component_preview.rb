# @label Footer
# @logical_path landing/footer
class Landing::FooterComponentPreview < Lookbook::Preview
  layout "landing"

  # @label Default
  # Rodapé da landing page com logo, links e redes sociais.
  def default
    render Landing::FooterComponent.new
  end
end
