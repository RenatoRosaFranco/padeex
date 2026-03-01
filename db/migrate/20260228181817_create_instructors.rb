# frozen_string_literal: true

class CreateInstructors < ActiveRecord::Migration[8.1]
  def change
    create_table :instructors do |t|
      t.references :tenant,        null: true,  foreign_key: true
      t.references :club,          null: false, foreign_key: { to_table: :users }
      t.references :user,          null: true,  foreign_key: true
      t.string     :name,          null: false
      t.string     :email
      t.string     :phone
      t.text       :description
      t.string     :internal_code

      t.timestamps
    end

    add_index :instructors, [:club_id, :internal_code],
              unique: true,
              where: "internal_code IS NOT NULL",
              name: "index_instructors_on_club_id_and_internal_code"
  end
end
