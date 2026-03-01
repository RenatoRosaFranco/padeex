# frozen_string_literal: true

class AddTenantIdToWaitlistEntries < ActiveRecord::Migration[8.1]
  def change
    add_reference :waitlist_entries, :tenant, null: true, foreign_key: true
  end
end
