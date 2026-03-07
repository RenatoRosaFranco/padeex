# frozen_string_literal: true

class CreateBrandIntegrations < ActiveRecord::Migration[8.1]
  def change
    create_table :brand_integrations do |t|
      t.references :brand_profile, null: false, foreign_key: true
      t.string :provider,   null: false
      t.string :label
      t.string :store_url
      t.string :api_key
      t.string :status,     null: false, default: "inactive"

      t.timestamps
    end

    add_index :brand_integrations, [:brand_profile_id, :provider], unique: true
  end
end
