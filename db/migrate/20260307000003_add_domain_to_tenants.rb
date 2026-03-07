# frozen_string_literal: true

class AddDomainToTenants < ActiveRecord::Migration[8.1]
  def change
    add_column :tenants, :domain, :string
    add_index  :tenants, :domain, unique: true
  end
end
