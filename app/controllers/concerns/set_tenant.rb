# frozen_string_literal: true

# Sets Current.tenant from subdomain, param, or default (padel).
# Include in ApplicationController so all requests have tenant context.
#
# Resolution order:
#   1. Subdomain (e.g. handball.padeex.com)
#   2. Param ?tenant=handball
#   3. Default: padel
module SetTenant
  extend ActiveSupport::Concern

  # Default tenant slug when none is provided via subdomain or param.
  # @return [String]
  DEFAULT_TENANT_SLUG = "padel"

  included do
    before_action :set_current_tenant
  end

  private

  # Resolves tenant slug and assigns Current.tenant.
  # Falls back to default tenant if slug is not found.
  def set_current_tenant
    slug = tenant_slug_from_subdomain || tenant_slug_from_param || DEFAULT_TENANT_SLUG
    Current.tenant = Tenant.find_by(slug: slug) || Tenant.find_by(slug: DEFAULT_TENANT_SLUG)
  end

  # Extracts tenant slug from request subdomain (e.g. handball.padeex.com).
  # Ignores "www" subdomain.
  #
  # @return [String, nil]
  def tenant_slug_from_subdomain
    request.subdomain.presence if request.subdomain != "www"
  end

  # Extracts tenant slug from ?tenant= query param.
  #
  # @return [String, nil]
  def tenant_slug_from_param
    params[:tenant].presence
  end
end
