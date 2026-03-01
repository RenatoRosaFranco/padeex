# frozen_string_literal: true

class CreateTournaments < ActiveRecord::Migration[8.1]
  def change
    create_table :tournaments do |t|
      t.references :tenant,    null: true,  foreign_key: true
      t.references :club,      null: false, foreign_key: { to_table: :users }
      t.string     :name,      null: false
      t.text       :description
      t.date       :starts_on, null: false
      t.date       :ends_on,   null: false
      t.string     :status,    null: false, default: "draft"
      t.integer    :max_teams
      t.string     :format
      t.decimal    :entry_fee, precision: 8, scale: 2

      t.timestamps
    end

    add_index :tournaments, [:club_id, :starts_on]
    add_index :tournaments, [:tenant_id, :status]
  end
end
