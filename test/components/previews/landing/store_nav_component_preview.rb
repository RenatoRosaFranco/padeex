# @label Store Nav
# @logical_path landing/store_nav
class Landing::StoreNavComponentPreview < Lookbook::Preview
  layout "landing"

  # @label Default
  # Navbar usada na página da loja. Requer feature flag :store ativa.
  def default
    render Landing::StoreNavComponent.new
  end
end
