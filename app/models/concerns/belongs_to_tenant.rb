# frozen_string_literal: true

# Assigns Current.tenant to new records and scopes queries to current tenant.
# Include in models that are tenant-scoped (WaitlistEntry, InvestmentInterest, Post, User).
#
# @example
#   class WaitlistEntry < ApplicationRecord
#     belongs_to_tenant
#   end
module BelongsToTenant
  extend ActiveSupport::Concern

  included do
    belongs_to :tenant, optional: true
    default_scope { Current.tenant ? where(tenant_id: [nil, Current.tenant.id]) : all }
    before_validation :assign_tenant, on: :create
  end

  private

  # Assigns Current.tenant to new records when tenant_id is blank.
  # @return [void]
  def assign_tenant
    return if tenant_id.present?
    self.tenant_id = Current.tenant&.id
  end
end
