# @label Blog Nav
# @logical_path landing/blog_nav
class Landing::BlogNavComponentPreview < Lookbook::Preview
  layout "landing"

  # @label Default
  # Navbar usada nas páginas do blog.
  def default
    render Landing::BlogNavComponent.new
  end
end
