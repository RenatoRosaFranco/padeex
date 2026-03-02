# frozen_string_literal: true

# Resolves segment content from YAML config with tenant and fallback logic.
# Supports nested (padel: { athletes: {...} }) and flat (athletes: {...}) structures.
#
# @example
#   SegmentContentResolver.call(config: config, segment_key: :athletes, tenant_slug: :padel)
class SegmentContentResolver < ApplicationService
  # Default tenant slug
  DEFAULT_TENANT_SLUG = :padel

  # @param config [Hash] Full segment content config (symbolized keys).
  # @param segment_key [Symbol] Segment slug (athletes, clubs, investors, companies).
  # @param tenant_slug [Symbol] Tenant slug (padel, handball, etc).
  def initialize(config:, segment_key:, tenant_slug: DEFAULT_TENANT_SLUG)
    @config = config
    @segment_key = segment_key
    @tenant_slug = tenant_slug
  end

  # @return [Hash] resolved content for the segment, or {} when not found
  def call
    # Nested: padel: { athletes: {...} }
    tenant_content = @config[@tenant_slug]
    segment_content = tenant_content&.dig(@segment_key)

    # Fallback: flat structure (legacy) or default tenant
    segment_content ||= @config[DEFAULT_TENANT_SLUG]&.dig(@segment_key)
    segment_content ||= @config[@segment_key] # flat: athletes: {...}
    segment_content ||= @config[:default]&.dig(@segment_key)
    segment_content || @config[:default] || {}
  end
end
