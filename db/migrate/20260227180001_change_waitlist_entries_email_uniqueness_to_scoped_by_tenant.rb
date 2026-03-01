# frozen_string_literal: true

class ChangeWaitlistEntriesEmailUniquenessToScopedByTenant < ActiveRecord::Migration[8.1]
  def change
    remove_index :waitlist_entries, :email
    add_index :waitlist_entries, [:tenant_id, :email], unique: true
  end
end
