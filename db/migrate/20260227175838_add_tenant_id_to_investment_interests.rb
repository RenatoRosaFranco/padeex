# frozen_string_literal: true

class AddTenantIdToInvestmentInterests < ActiveRecord::Migration[8.1]
  def change
    add_reference :investment_interests, :tenant, null: true, foreign_key: true
  end
end
