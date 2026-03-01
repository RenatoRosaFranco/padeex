# frozen_string_literal: true

class CreateTournamentMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :tournament_matches do |t|
      t.references :tournament_category, null: false, foreign_key: true
      t.references :tournament_group,    foreign_key: true
      t.references :court,               foreign_key: true
      t.references :tenant
      t.bigint :home_registration_id, null: false
      t.bigint :away_registration_id, null: false
      t.integer  :home_score
      t.integer  :away_score
      t.datetime :scheduled_at
      t.string   :status,    null: false, default: "scheduled"
      t.integer  :position,  default: 0
      t.timestamps
    end

    add_foreign_key :tournament_matches, :tournament_registrations, column: :home_registration_id
    add_foreign_key :tournament_matches, :tournament_registrations, column: :away_registration_id
    add_index :tournament_matches, :home_registration_id
    add_index :tournament_matches, :away_registration_id
  end
end
