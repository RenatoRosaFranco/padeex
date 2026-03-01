# frozen_string_literal: true

class CreateCourts < ActiveRecord::Migration[8.1]
  def change
    create_table :courts do |t|
      t.references :tenant, null: true, foreign_key: true
      t.string :name, null: false
      t.string :court_type, null: false
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :courts, [:tenant_id, :name], unique: true
  end
end
