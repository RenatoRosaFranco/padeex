# frozen_string_literal: true

class AddClubToCourts < ActiveRecord::Migration[8.1]
  def change
    add_reference :courts, :club, null: true, foreign_key: { to_table: :users }
    add_index :courts, [:club_id, :name], unique: true, where: "club_id IS NOT NULL"
  end
end
