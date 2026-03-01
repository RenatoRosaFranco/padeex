# frozen_string_literal: true

class CreateClubProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :club_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :club_name
      t.string :cnpj
      t.string :address
      t.string :phone
      t.string :email
      t.string :website
      t.text   :description

      t.timestamps
    end
  end
end
