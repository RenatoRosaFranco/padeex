# frozen_string_literal: true

class CreateTournamentRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :tournament_registrations do |t|
      t.references :tournament_category, null: false, foreign_key: true
      t.references :user,                null: false, foreign_key: true
      t.references :tenant
      t.string  :partner_name
      t.string  :partner_phone
      t.string  :status,    null: false, default: "pending"
      t.integer :position,  default: 0
      t.timestamps
    end

    add_index :tournament_registrations,
              [:tournament_category_id, :user_id],
              unique: true,
              name: "idx_unique_tournament_registration"
    add_index :tournament_registrations, [:tournament_category_id, :status]
  end
end
