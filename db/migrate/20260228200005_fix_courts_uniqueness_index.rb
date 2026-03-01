# frozen_string_literal: true

class FixCourtsUniquenessIndex < ActiveRecord::Migration[8.1]
  def change
    remove_index :courts, name: "index_courts_on_tenant_id_and_name"
  end
end
