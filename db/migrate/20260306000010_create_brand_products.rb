# frozen_string_literal: true

class CreateBrandProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :brand_products do |t|
      t.references :brand_profile, null: false, foreign_key: true
      t.string  :name,         null: false
      t.text    :description
      t.integer :price_cents,  null: false, default: 0
      t.string  :category
      t.string  :status,       null: false, default: "draft"
      t.string  :external_url
      t.integer :position,     null: false, default: 0

      t.timestamps
    end

    add_index :brand_products, [:brand_profile_id, :status]
  end
end
