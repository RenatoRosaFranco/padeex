# frozen_string_literal: true

class CreateUserProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string  :username
      t.date    :birth_date
      t.string  :gender
      t.text    :bio

      t.timestamps
    end

    add_index :user_profiles, :username, unique: true
  end
end
