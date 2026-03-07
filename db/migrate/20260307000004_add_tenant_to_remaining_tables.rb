# frozen_string_literal: true

class AddTenantToRemainingTables < ActiveRecord::Migration[8.1]
  def up
    tables = %i[
      club_profiles brand_profiles brand_products
      brand_product_categories brand_integrations
      follows notifications user_profiles tournament_group_memberships
    ]

    tables.each do |table|
      add_reference table, :tenant, foreign_key: true, null: true, index: true
    end

    # Backfill via joins
    execute <<~SQL
      UPDATE club_profiles cp
      SET tenant_id = u.tenant_id
      FROM users u WHERE cp.user_id = u.id
    SQL

    execute <<~SQL
      UPDATE brand_profiles bp
      SET tenant_id = u.tenant_id
      FROM users u WHERE bp.user_id = u.id
    SQL

    execute <<~SQL
      UPDATE brand_products bpr
      SET tenant_id = bp.tenant_id
      FROM brand_profiles bp WHERE bpr.brand_profile_id = bp.id
    SQL

    execute <<~SQL
      UPDATE brand_product_categories bpc
      SET tenant_id = bp.tenant_id
      FROM brand_profiles bp WHERE bpc.brand_profile_id = bp.id
    SQL

    execute <<~SQL
      UPDATE brand_integrations bi
      SET tenant_id = bp.tenant_id
      FROM brand_profiles bp WHERE bi.brand_profile_id = bp.id
    SQL

    execute <<~SQL
      UPDATE follows f
      SET tenant_id = u.tenant_id
      FROM users u WHERE f.follower_id = u.id
    SQL

    execute <<~SQL
      UPDATE notifications n
      SET tenant_id = u.tenant_id
      FROM users u WHERE n.user_id = u.id
    SQL

    execute <<~SQL
      UPDATE user_profiles up
      SET tenant_id = u.tenant_id
      FROM users u WHERE up.user_id = u.id
    SQL

    execute <<~SQL
      UPDATE tournament_group_memberships tgm
      SET tenant_id = t.tenant_id
      FROM tournament_registrations tr
      JOIN tournament_categories tc ON tc.id = tr.tournament_category_id
      JOIN tournaments t ON t.id = tc.tournament_id
      WHERE tgm.tournament_registration_id = tr.id
    SQL
  end

  def down
    %i[
      club_profiles brand_profiles brand_products
      brand_product_categories brand_integrations
      follows notifications user_profiles tournament_group_memberships
    ].each do |table|
      remove_reference table, :tenant, foreign_key: true, index: true
    end
  end
end
