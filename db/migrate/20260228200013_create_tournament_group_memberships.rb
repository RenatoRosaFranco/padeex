# frozen_string_literal: true

class CreateTournamentGroupMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :tournament_group_memberships do |t|
      t.references :tournament_group,        null: false, foreign_key: true
      t.references :tournament_registration, null: false, foreign_key: true
      t.integer :position, default: 0
      t.timestamps
    end

    add_index :tournament_group_memberships,
              [:tournament_group_id, :tournament_registration_id],
              unique: true,
              name: "idx_unique_group_membership"
  end
end
