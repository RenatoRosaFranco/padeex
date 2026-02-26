# frozen_string_literal: true

class CreateUserIdentities < ActiveRecord::Migration[8.1]
  def change
    create_table :user_identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid,      null: false
      t.timestamps
    end

    add_index :user_identities, [:provider, :uid], unique: true

    reversible do |dir|
      dir.up do
        execute <<~SQL
          INSERT INTO user_identities (user_id, provider, uid, created_at, updated_at)
          SELECT id, provider, uid, NOW(), NOW()
          FROM users
          WHERE provider IS NOT NULL AND uid IS NOT NULL
          ON CONFLICT (provider, uid) DO NOTHING
        SQL
      end
    end
  end
end
