# frozen_string_literal: true

class AddTenantToUserIdentities < ActiveRecord::Migration[8.1]
  def up
    add_reference :user_identities, :tenant, foreign_key: true, null: true, index: true

    # Backfill from the associated user
    execute <<~SQL
      UPDATE user_identities ui
      SET tenant_id = u.tenant_id
      FROM users u WHERE ui.user_id = u.id
    SQL

    # The uniqueness of (provider, uid) must now be scoped per tenant
    # so the same OAuth account can exist independently on each tenant
    remove_index :user_identities, [:provider, :uid]
    add_index    :user_identities, [:tenant_id, :provider, :uid], unique: true
  end

  def down
    remove_index  :user_identities, [:tenant_id, :provider, :uid]
    add_index     :user_identities, [:provider, :uid], unique: true
    remove_reference :user_identities, :tenant, foreign_key: true, index: true
  end
end
