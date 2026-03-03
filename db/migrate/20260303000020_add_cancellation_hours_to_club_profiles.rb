# frozen_string_literal: true

class AddCancellationHoursToClubProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :club_profiles, :cancellation_hours, :integer, default: 3, null: false
  end
end
