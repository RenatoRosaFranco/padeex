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

  DEFAULT_TENANT_SLUG = "padel"

  included do
    before_action :set_current_tenant
  end

  private

  def set_current_tenant
    slug = tenant_slug_from_subdomain || tenant_slug_from_param || DEFAULT_TENANT_SLUG
    Current.tenant = Tenant.find_by(slug: slug) || Tenant.find_by(slug: DEFAULT_TENANT_SLUG)
  end

  def tenant_slug_from_subdomain
    request.subdomain.presence if request.subdomain != "www"
  end

  def tenant_slug_from_param
    params[:tenant].presence
  end
end
