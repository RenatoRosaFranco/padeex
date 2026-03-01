# frozen_string_literal: true

class CreateTenants < ActiveRecord::Migration[8.1]
  def change
    create_table :tenants do |t|
      t.string :slug, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :tenants, :slug, unique: true
  end
end
