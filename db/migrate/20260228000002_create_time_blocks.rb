# frozen_string_literal: true

class CreateTimeBlocks < ActiveRecord::Migration[8.1]
  def change
    create_table :time_blocks do |t|
      t.references :tenant, null: true, foreign_key: true
      t.references :court, null: false, foreign_key: true
      t.date :date, null: false
      t.time :starts_at, null: false
      t.time :ends_at, null: false
      t.string :reason, null: false

      t.timestamps
    end

    add_index :time_blocks, [:court_id, :date]
  end
end
