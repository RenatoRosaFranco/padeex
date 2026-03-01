# frozen_string_literal: true

class AddTenantIdToPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :posts, :tenant, null: true, foreign_key: true
  end
end
