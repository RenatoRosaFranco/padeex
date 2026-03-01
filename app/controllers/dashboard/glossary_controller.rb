# frozen_string_literal: true

class Dashboard::GlossaryController < Dashboard::BaseController
  GLOSSARY_DIR = Rails.root.join("data/glossary")

  def index
    @categories = load_glossary
  end

  private

  def load_glossary
    slug = Current.tenant&.slug || SetTenant::DEFAULT_TENANT_SLUG
    path = GLOSSARY_DIR.join("#{slug}.yml")
    path = GLOSSARY_DIR.join("#{SetTenant::DEFAULT_TENANT_SLUG}.yml") unless path.exist?
    YAML.load_file(path, symbolize_names: true)
  end
end
