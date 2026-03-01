# frozen_string_literal: true

class CreateTournamentCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :tournament_categories do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :tenant
      t.string  :name,                  null: false
      t.text    :description
      t.string  :gender
      t.string  :level
      t.integer :max_pairs
      t.decimal :entry_fee,             precision: 8, scale: 2
      t.date    :registration_deadline
      t.integer :position,              default: 0
      t.timestamps
    end

    add_index :tournament_categories, [:tournament_id, :position]
  end
end
