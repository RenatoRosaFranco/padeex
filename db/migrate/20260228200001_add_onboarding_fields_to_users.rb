# frozen_string_literal: true

class AddOnboardingFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :cpf,                  :string
    add_column :users, :onboarding_completed, :boolean, default: false, null: false
  end
end
