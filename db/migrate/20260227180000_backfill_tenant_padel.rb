# frozen_string_literal: true

class BackfillTenantPadel < ActiveRecord::Migration[8.1]
  def up
    padel = Tenant.find_or_create_by!(slug: "padel") { |t| t.name = "Padel" }

    [WaitlistEntry, InvestmentInterest, Post].each do |model|
      model.unscoped.where(tenant_id: nil).update_all(tenant_id: padel.id)
    end

    execute("UPDATE users SET tenant_id = #{padel.id} WHERE tenant_id IS NULL")
  end

  def down
    # No-op: we don't want to nullify on rollback
  end
end
