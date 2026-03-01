# frozen_string_literal: true

# Thread-safe storage for request-scoped attributes (e.g. current tenant).
# Used for multi-tenant support: padel, handball, football, futsal, etc.
#
# @example
#   Current.tenant = Tenant.find_by(slug: "padel")
#   Current.tenant # => #<Tenant slug: "padel">
class Current < ActiveSupport::CurrentAttributes
  attribute :tenant
end
