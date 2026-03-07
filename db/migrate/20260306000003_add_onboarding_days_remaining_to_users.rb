# frozen_string_literal: true

class AddOnboardingDaysRemainingToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :onboarding_days_remaining, :integer, null: false, default: 7
  end
end
