# frozen_string_literal: true

# Resolves Current.tenant from the request host or fallback param.
#
# Resolution order:
#   1. request.host matches tenant.domain  (e.g. padeex.com.br → padel)
#   2. ?tenant= param                      (development / testing only)
#   3. Default: padel
module SetTenant
  extend ActiveSupport::Concern

  DEFAULT_TENANT_SLUG = "padel"

  included do
    before_action :set_current_tenant
  end

  private

  def set_current_tenant
    Current.tenant =
      tenant_from_domain ||
      tenant_from_param  ||
      Tenant.find_by(slug: DEFAULT_TENANT_SLUG) ||
      Tenant.first
  end

  def tenant_from_domain
    Tenant.find_by(domain: request.host)
  end

  def tenant_from_param
    slug = params[:tenant].presence
    Tenant.find_by(slug: slug) if slug
  end
end
