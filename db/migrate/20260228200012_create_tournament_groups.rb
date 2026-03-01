# frozen_string_literal: true

class CreateTournamentGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :tournament_groups do |t|
      t.references :tournament_category, null: false, foreign_key: true
      t.references :tenant
      t.string  :name,     null: false
      t.integer :position, default: 0
      t.timestamps
    end

    add_index :tournament_groups, [:tournament_category_id, :position]
  end
end
