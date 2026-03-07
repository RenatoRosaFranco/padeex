# frozen_string_literal: true

class CreateBrandProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :brand_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :brand_name
      t.string :cnpj
      t.string :website
      t.string :phone
      t.string :email
      t.string :category
      t.text   :description

      t.timestamps
    end
  end
end
