# frozen_string_literal: true

class CreateBrandProductCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :brand_product_categories do |t|
      t.references :brand_profile, null: false, foreign_key: true
      t.string  :name,     null: false
      t.string  :color,    null: false, default: "#3628c5"
      t.string  :icon,     null: false, default: "box-fill"
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :brand_product_categories, [:brand_profile_id, :name],
              unique: true, name: "index_brand_product_categories_on_profile_and_name"

    add_reference :brand_products, :brand_product_category, foreign_key: true
    remove_column :brand_products, :category, :string
  end
end
