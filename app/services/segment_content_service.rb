# frozen_string_literal: true

# Loads content for segmented landing pages. Supports multi-tenant (padel, handball, football, futsal).
# Content is nested by tenant slug; falls back to padel when tenant content is missing.
#
# @example
#   SegmentContentService.fetch("athletes", tenant: Current.tenant)
class SegmentContentService
  PATH = Rails.root.join("data/segment_content.yml")
  DEFAULT_TENANT_SLUG = "padel"

  # @param slug [String] Segment slug (athletes, clubs, investors, companies).
  # @param tenant [Tenant, nil] Current tenant. Uses padel when nil.
  # @return [Hash] Content for the segment.
  def self.fetch(slug, tenant: nil)
    segment_key = slug.to_s.presence&.to_sym
    tenant_slug = (tenant&.slug || DEFAULT_TENANT_SLUG).to_sym

    SegmentContentResolver.call(
      config: config,
      segment_key: segment_key,
      tenant_slug: tenant_slug
    )
  end

  # @return [Hash] Full config with symbolized keys.
  def self.config
    @config ||= YAML.load_file(PATH, symbolize_names: true) || {}
  end

  private_class_method :config
end
